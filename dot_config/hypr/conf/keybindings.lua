-- ░█░█░█▀▀░█░█░█▀▄░▀█▀░█▀█░█▀▄░█▀▀
-- ░█▀▄░█▀▀░░█░░█▀▄░░█░░█░█░█░█░▀▀█
-- ░▀░▀░▀▀▀░░▀░░▀▀░░▀▀▀░▀░▀░▀▀░░▀▀▀

local mod = "SUPER"

-- Replaces the $terminal / $fileManager / $menu / $screenShot vars from
-- conf/variables.conf, which hyprlang needed and Lua does not.
local apps = {
	terminal = "kitty",
	file_manager = "thunar",
	menu = "rofi -show drun",
	screenshot = 'grim -g "$(slurp -d)" - | swappy -f -',
	clipboard = "cliphist list | rofi -dmenu | cliphist decode | wl-copy",
}

-- Applications
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(apps.terminal), { description = "Terminal" })
hl.bind(mod .. " + E", hl.dsp.exec_cmd(apps.file_manager), { description = "File manager" })
hl.bind(mod .. " + BACKSPACE", hl.dsp.exec_cmd(apps.menu), { description = "App launcher" })
hl.bind(mod .. " + A", hl.dsp.exec_cmd(apps.screenshot), { description = "Screenshot region" })
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd(apps.clipboard), { description = "Clipboard history" })

-- misc.disable_autoreload is on, so reloading is explicit
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Reload config" })

-- Window state
hl.bind(mod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Maximize" })
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Fullscreen" })
hl.bind(mod .. " + I", hl.dsp.window.pin(), { description = "Pin window" })

-- hyprlang bound SUPER+T to both togglefloating and centerwindow; Lua allows one
-- bind per combo, so they merge.
hl.bind(mod .. " + T", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.center())
end, { description = "Float and center" })

-- Layout
hl.bind(mod .. " + V", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(mod .. " + SHIFT + G", hl.dsp.group.toggle(), { description = "Toggle group" })

-- Focus
local directions = { h = "left", j = "down", k = "up", l = "right" }
for key, direction in pairs(directions) do
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = direction }), {
		description = "Focus " .. direction,
	})
end

-- Move window within the workspace
for key, direction in pairs(directions) do
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }), {
		description = "Move window " .. direction,
	})
end

-- Long-press the same keys to throw the window at the next monitor instead
for key, direction in pairs(directions) do
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ monitor = direction }), {
		long_press = true,
		description = "Move window to " .. direction .. " monitor",
	})
end

-- Move the whole workspace to another monitor.
-- hyprlang used an undefined $mainMod_CTRL here, so these never worked.
local workspace_monitor_keys = { a = "left", s = "down", d = "up", f = "right" }
for key, direction in pairs(workspace_monitor_keys) do
	hl.bind(mod .. " + CTRL + " .. key, hl.dsp.workspace.move({ monitor = direction }), {
		description = "Move workspace to " .. direction .. " monitor",
	})
end

-- Resize / move the active window by keyboard
local nudges = { h = { -30, 0 }, j = { 0, 30 }, k = { 0, -30 }, l = { 30, 0 } }
for key, delta in pairs(nudges) do
	hl.bind(mod .. " + CTRL + " .. key, hl.dsp.window.resize({ x = delta[1], y = delta[2], relative = true }), {
		repeating = true,
		description = "Resize window",
	})
	hl.bind(mod .. " + ALT + " .. key, hl.dsp.window.move({ x = delta[1], y = delta[2], relative = true }), {
		description = "Nudge window",
	})
end

-- Workspaces
for i = 1, 10 do
	local key = i % 10 -- workspace 10 lives on key 0
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }), {
		description = "Workspace " .. i,
	})
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), {
		description = "Move window to workspace " .. i,
	})
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })

-- Scratchpad
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("ovr"), { description = "Toggle scratchpad" })
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:ovr" }), {
	description = "Move window to scratchpad",
})

-- Mouse drag
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { description = "Drag window" })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { description = "Resize window with mouse" })

-- ░█▄█░█▀▀░█▀▄░▀█▀░█▀█░░░█░█░█▀▀░█░█░█▀▀
-- ░█░█░█▀▀░█░█░░█░░█▀█░░░█▀▄░█▀▀░░█░░▀▀█
-- ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀░▀░░░▀░▀░▀▀▀░░▀░░▀▀▀

local osd = {
	{ "XF86AudioRaiseVolume", "--output-volume 5", "Volume up" },
	{ "XF86AudioLowerVolume", "--output-volume -5", "Volume down" },
	{ "XF86AudioMute", "--output-volume mute-toggle", "Mute output" },
	{ "XF86AudioMicMute", "--input-volume mute-toggle", "Mute microphone" },
	{ "XF86MonBrightnessUp", "--brightness raise", "Brightness up" },
	{ "XF86MonBrightnessDown", "--brightness lower", "Brightness down" },
}
for _, entry in ipairs(osd) do
	local key, args, description = entry[1], entry[2], entry[3]
	hl.bind(key, hl.dsp.exec_cmd("swayosd-client " .. args), {
		locked = true,
		repeating = true,
		description = description,
	})
end

-- Requires playerctl. Each shells out because swayosd needs the resulting state.
local media = {
	{
		"XF86AudioNext",
		[[playerctl next; swayosd-client --custom-message="next" --custom-icon="media-skip-forward"]],
		"Next track",
	},
	{
		"XF86AudioPrev",
		[[playerctl previous; swayosd-client --custom-message="previous" --custom-icon="media-skip-backward"]],
		"Previous track",
	},
	{
		"XF86AudioPause",
		[[playerctl play-pause; swayosd-client --custom-message="pause" --custom-icon="media-playback-pause"]],
		"Pause",
	},
	{
		"XF86AudioPlay",
		[[status=$(playerctl status); icon=$( [ "$status" = "Playing" ] && echo "pause" || echo "start" ); ]]
			.. [[playerctl play-pause; swayosd-client --custom-message="$status" --custom-icon="media-playback-$icon"]],
		"Play/pause",
	},
}
for _, entry in ipairs(media) do
	local key, script, description = entry[1], entry[2], entry[3]
	hl.bind(key, hl.dsp.exec_cmd("sh -c '" .. script .. "'"), {
		locked = true,
		description = description,
	})
end
