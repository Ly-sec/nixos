# Run from repo root: just <recipe>

fmt:
    nixfmt $(find . -name '*.nix' -not -path './result*' -not -path './.git/*')

check:
    #!/usr/bin/env bash
    set -euo pipefail
    # Full-tree lint (lefthook only checks staged files on commit).
    # -L matches lefthook: unused { pkgs, ... } module args are normal.
    echo "==> statix"
    statix check .
    echo "==> deadnix"
    deadnix --fail -L .
    echo "ok"

hooks:
    lefthook install
