-- ░█░█░▀█▀░█▀█░█▀▄░█▀█░█░█░░░█▀▄░█░█░█░░░█▀▀░█▀▀
-- ░█▄█░░█░░█░█░█░█░█░█░█▄█░░░█▀▄░█░█░█░░░█▀▀░▀▀█
-- ░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀░░░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀
--
-- hyprlang needed one `windowrule =` line per effect. A Lua rule carries every
-- effect for a matcher in one table, so ~40 lines become 13 rules.

hl.window_rule({
    name = "terminal-popin",
    match = { class = "^(kitty|dev.warp.Warp|com.mitchellh.ghostty)$" },
    animation = "popin",
})

-- Widened from `^$` (which matched nothing, so this rule was dead in hyprlang) to
-- `.*`, matching upstream's example. Apps can no longer maximize themselves.
hl.window_rule({
    name = "ignore-maximize-requests",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "danmufloat-pin",
    match = { title = "^(danmufloat)$" },
    pin = true,
})

hl.window_rule({
    name = "pavucontrol",
    match = { class = "^(org.pulseaudio.pavucontrol)$" },
    float = true,
    size = { 800, 600 },
})

hl.window_rule({
    name = "polkit-agent",
    match = { class = "^(polkit-gnome-authentication-agent-1)$" },
    size = { 300, 300 },
    float = true,
    center = true,
    pin = true,
    stay_focused = true,
    border_size = 10,
    dim_around = true,
})

hl.window_rule({
    name = "gnome-keyring-prompt",
    match = { class = "gcr-prompter", title = "^Unlock Keyring$" },
    center = true,
    border_size = 10,
    stay_focused = true,
})

hl.window_rule({
    name = "1password-main",
    match = { class = "^1Password$", title = "^1Password$" },
    center = true,
    border_size = 10,
    float = true,
    dim_around = true,
})

hl.window_rule({
    name = "1password-quick-access",
    match = { class = "^1Password$", title = "^Quick Access$" },
    center = true,
    float = true,
})

hl.window_rule({
    name = "xwayland-open-file-dialog",
    match = { class = "Xdg-desktop-portal-gtk", title = "^Open File$" },
    float = true,
    center = true,
})

hl.window_rule({
    name = "screen-share-picker",
    match = { class = "^hyprland-share-picker$" },
    float = true,
    center = true,
    pin = true,
    stay_focused = true,
    border_size = 10,
    dim_around = true,
})

hl.window_rule({
    name = "picture-in-picture",
    match = { title = "^Picture-in-Picture$" },
    float = true,
    size = { 960, 540 },
    move = { "25%-", 0 },
})

hl.window_rule({
    name = "rider-rename-dialog",
    match = { class = "jetbrains-rider", title = "^Rename$" },
    stay_focused = true,
})
