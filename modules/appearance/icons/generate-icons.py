"""Generate and select a cached Gruvbox Plus theme from a Noctalia palette."""

import argparse
import fcntl
import hashlib
import json
import os
import re
import shutil
import signal
import subprocess
import sys
import tempfile
from pathlib import Path

PREFIX = "Noctalia-Gruvbox-"
MARKER = ".noctalia-gruvbox"
CACHE_SIZE = 4
GRUVBOX_HUES = {
    "red": ("#9d0006", "#cc241d", "#fb4934"),
    "green": ("#79740e", "#98971a", "#b8bb26"),
    "yellow": ("#b57614", "#d79921", "#fabd2f"),
    "blue": ("#076678", "#458588", "#83a598"),
    "magenta": ("#8f3f71", "#b16286", "#d3869b"),
    "cyan": ("#427b58", "#689d6a", "#8ec07c"),
}
GRUVBOX_ORANGES = ("#af3a03", "#d65d0e", "#fe8019")
CHROMATIC_COLORS = {
    color.encode()
    for shades in (*GRUVBOX_HUES.values(), GRUVBOX_ORANGES)
    for color in shades
}
THEME_NAME = re.compile(rf"{PREFIX}[0-9a-f]{{20}}")
HEX_COLOR = re.compile(r"#[0-9a-fA-F]{6}")
SVG_COLOR = re.compile(rb"#[0-9a-fA-F]{6}(?![0-9a-fA-F])")
CSS_ROLE = re.compile(
    rb"(\.ColorScheme-(Text|Highlight)\s*\{[^}]*?\bcolor\s*:\s*)#[0-9a-fA-F]{6}"
)
SETTINGS = ["gsettings", "org.gnome.desktop.interface", "icon-theme"]


def mix(first, second, amount):
    channels = (
        round(
            int(first[i : i + 2], 16) * (1 - amount)
            + int(second[i : i + 2], 16) * amount
        )
        for i in (1, 3, 5)
    )
    return "#" + "".join(f"{channel:02x}" for channel in channels)


def color_map(palette):
    if palette["mode"] not in ("dark", "light"):
        raise ValueError("palette mode must be dark or light")

    colors = [palette[key] for key in ("primary", "background", "foreground")]
    for group in ("normal", "bright"):
        colors.extend(
            palette[group][key]
            for key in ("red", "green", "yellow", "blue", "magenta", "cyan", "white")
        )
    if any(
        not isinstance(color, str) or not HEX_COLOR.fullmatch(color) for color in colors
    ):
        raise ValueError("palette colors must use #RRGGBB")

    background, foreground = palette["background"], palette["foreground"]
    # Preserve the neutral shading when the foreground/background polarity changes.
    neutral = {
        "#282828": 0.0,
        "#32302f": 0.04,
        "#3c3836": 0.08,
        "#504945": 0.18,
        "#665c54": 0.28,
        "#7c6f64": 0.38,
        "#928374": 0.48,
        "#a89984": 0.60,
        "#bdae93": 0.72,
        "#d5c4a1": 0.85,
        "#ebdbb2": 1.0,
    }
    mapping = {
        color: mix(background, foreground, amount) for color, amount in neutral.items()
    }
    mapping["#1d2021"] = background
    mapping["#d5c4a1"] = palette["normal"]["white"]
    for color in ("#fbf1c7", "#f2e5bc", "#f9f5d7"):
        mapping[color] = palette["bright"]["white"]

    for hue, original in GRUVBOX_HUES.items():
        dim, normal, bright = original
        mapping[dim] = mix(palette["normal"][hue], background, 0.25)
        mapping[normal] = palette["normal"][hue]
        mapping[bright] = palette["bright"][hue]

    orange = mix(palette["normal"]["red"], palette["normal"]["yellow"], 0.5)
    mapping["#af3a03"] = mix(orange, background, 0.25)
    mapping["#d65d0e"] = orange
    mapping["#fe8019"] = mix(palette["bright"]["red"], palette["bright"]["yellow"], 0.5)
    return {key.encode(): value.lower().encode() for key, value in mapping.items()}


def build_theme(source, target, palette, mapping, digest):
    roles = {
        b"Text": palette["foreground"].encode(),
        b"Highlight": palette["primary"].encode(),
    }

    def copy_icon(src, dst):
        path = Path(src)
        if path.suffix != ".svg":
            return shutil.copyfile(src, dst)
        original = path.read_bytes()
        relative = path.relative_to(source)
        # Share immutable colored app icons with the installed theme. Monochrome
        # app icons still need foreground mapping for contrast in both modes.
        colored_app = (
            relative.parts[0] == "apps"
            and "symbolic" not in relative.parts
            and not path.name.endswith("-symbolic.svg")
            and any(
                color.lower() in CHROMATIC_COLORS
                for color in SVG_COLOR.findall(original)
            )
        )
        if colored_app:
            os.symlink(path, dst)
            return dst
        recolored = SVG_COLOR.sub(
            lambda match: mapping.get(match[0].lower(), match[0]), original
        )
        recolored = CSS_ROLE.sub(lambda match: match[1] + roles[match[2]], recolored)
        Path(dst).write_bytes(recolored)
        return dst

    # Dark is self-contained; the light theme links into it. Recoloring its neutral
    # ramp and embedded CSS roles produces both modes without dangling links.
    shutil.copytree(
        source,
        target,
        symlinks=True,
        copy_function=copy_icon,
        ignore=shutil.ignore_patterns("icon-theme.cache"),
    )
    for root, _, _ in os.walk(target):
        Path(root).chmod(0o755)

    index = target / "index.theme"
    content = re.sub(
        r"^Name=.*$", "Name=Noctalia Gruvbox", index.read_text(), flags=re.MULTILINE
    )
    index.write_text(content)
    subprocess.run(
        ["gtk-update-icon-cache", "--force", "--quiet", str(target)], check=True
    )
    (target / MARKER).write_text(digest)


def prune(icons, current, previous):
    candidates = [
        path
        for path in icons.iterdir()
        if THEME_NAME.fullmatch(path.name)
        and not path.is_symlink()
        and (path / MARKER).is_file()
    ]
    keep = {
        name
        for name in (current, previous)
        if any(path.name == name for path in candidates)
    }
    for path in sorted(
        candidates, key=lambda path: (path / MARKER).stat().st_mtime, reverse=True
    ):
        if path.name in keep:
            continue
        if len(keep) < CACHE_SIZE:
            keep.add(path.name)
        else:
            shutil.rmtree(path)


def generate(source, palette_path):
    data_home = Path(os.environ.get("XDG_DATA_HOME") or Path.home() / ".local/share")
    icons = data_home / "icons"
    icons.mkdir(parents=True, exist_ok=True)

    with (icons / ".noctalia-gruvbox.lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        raw = palette_path.read_bytes()
        palette = json.loads(raw)
        mapping = color_map(palette)
        digest = hashlib.sha256(
            Path(__file__).read_bytes()
            + str(source).encode()
            + json.dumps(palette, sort_keys=True).encode()
        ).hexdigest()
        name = PREFIX + digest[:20]
        target = icons / name

        # The lock ensures these can only be remnants of an interrupted build.
        for path in icons.glob(".noctalia-gruvbox-build-*"):
            if path.is_dir() and not path.is_symlink():
                shutil.rmtree(path)

        if target.exists():
            if (target / MARKER).read_text() != digest:
                raise ValueError(f"unrecognized theme directory: {target}")
        else:
            with tempfile.TemporaryDirectory(
                prefix=".noctalia-gruvbox-build-", dir=icons
            ) as tmp:
                work = Path(tmp) / name
                build_theme(source, work, palette, mapping, digest)
                work.rename(target)

        # A newer template render may have arrived while this palette was building.
        if palette_path.read_bytes() != raw:
            return

        previous = (
            subprocess.check_output([SETTINGS[0], "get", *SETTINGS[1:]], text=True)
            .strip()
            .strip("'")
        )
        if previous != name:
            subprocess.run([SETTINGS[0], "set", *SETTINGS[1:], name], check=True)
        (target / MARKER).touch()
        prune(icons, name, previous)
        print(target)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("palette", type=Path, help="JSON palette rendered by Noctalia")
    args = parser.parse_args()
    generate(args.source, args.palette)


if __name__ == "__main__":
    # Let TemporaryDirectory clean up if Noctalia terminates a running hook.
    signal.signal(signal.SIGTERM, lambda number, _frame: sys.exit(128 + number))
    try:
        main()
    except (
        OSError,
        ValueError,
        KeyError,
        TypeError,
        subprocess.CalledProcessError,
    ) as error:
        sys.exit(f"Warning: could not apply Noctalia icons: {error}")
