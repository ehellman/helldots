-- Everything here ran as `exec-once` (or `exec`) in hyprland.conf.
--
-- A nested Hyprland instance shares the user's session bus, so starting a
-- second waybar / hypridle / polkit agent from a test run would fight with the
-- real one. Skip the whole file when HYPR_NESTED is set.
if os.getenv("HYPR_NESTED") ~= nil then
    return
end

local once = {
    -- screen sharing needs the session bus to know about the wayland display
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",

    "hypridle",
    "hyprpm reload -n",

    -- awww-daemon stays in the foreground, so wait for its socket before
    -- sending it a command
    "awww-daemon",
    "for _ in $(seq 50); do awww query > /dev/null 2>&1 && break; sleep 0.1; done; awww clear 000000",

    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",

    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",

    -- gtk dark mode: gtk4 reads color-scheme, gtk3 needs the adw-gtk3 theme
    'gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"',
    'gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"',

    "nm-applet --indicator",
    "swaync",
    "waybar",
    "swayosd-server",
}

hl.on("hyprland.start", function()
    for _, cmd in ipairs(once) do
        hl.exec_cmd(cmd)
    end
end)
