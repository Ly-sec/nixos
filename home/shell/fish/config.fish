function fish_greeting
    if test -t 1
        # microfetch uses ANSI palette slots; Ghostty's theme maps them.
        env -u NO_COLOR microfetch
    end
end

if status is-interactive
    set -gx GPG_TTY (tty)

    if test -d "$HOME/.bun"
        set -gx BUN_INSTALL "$HOME/.bun"
        fish_add_path $BUN_INSTALL/bin
    end

    if test -d "$HOME/.opencode/bin"
        fish_add_path "$HOME/.opencode/bin"
    end
end
