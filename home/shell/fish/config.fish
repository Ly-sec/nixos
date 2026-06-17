function fish_greeting
    fastfetch
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
