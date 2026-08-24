-- Hyprland configuration.
--
-- API reference: /usr/share/hypr/stubs/hl.meta.lua
-- Example config: /usr/share/hypr/hyprland.lua

local theme = require("themes/monochrome")
-- local theme = require("themes/mocha")

-- ░█░░░█▀█░█▀█░█░█░░░█▀█░█▀█░█▀▄░░░█▀▀░█▀▀░█▀▀░█░░
-- ░█░░░█░█░█░█░█▀▄░░░█▀█░█░█░█░█░░░█▀▀░█▀▀░█▀▀░█░░
-- ░▀▀▀░▀▀▀░▀▀▀░▀░▀░░░▀░▀░▀░▀░▀▀░░░░▀░░░▀▀▀░▀▀▀░▀▀▀

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = { top = 0, right = 10, bottom = 10, left = 10 },
		border_size = 2,
		col = {
			active_border = theme.rgb("text"),
			inactive_border = theme.rgb("surface1"),
		},
		-- resize windows by clicking and dragging on borders and gaps
		resize_on_border = true,
		hover_icon_on_border = true,
		-- see https://wiki.hypr.land/Configuring/Tearing/ before turning this on
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 8,
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			-- falloff [1-4]
			render_power = 3,
			-- size in px
			range = 4,
			-- ARGB; 100 90 80 70 60 50 40 30 20 10 0
			--       ff e6 cc b3 99 80 66 4c 33 19 00
			color = theme.rgba("mantle", "e6"),
			-- [0.0-1.0]
			scale = 1.0,
		},

		blur = {
			enabled = true,
			-- floating windows ignore tiled windows in their blur; needs
			-- new_optimizations, cuts floating-blur overhead significantly
			xray = true,
			size = 5,
			passes = 2,
			popups = true,
			-- make the blur layer ignore the window's opacity
			ignore_opacity = true,
			new_optimizations = true,
			vibrancy = 0.1696,
			special = true,
		},
	},

	group = {
		groupbar = {
			font_family = "0xProto Nerd Font Mono",
		},
	},

	animations = {
		enabled = false,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	ecosystem = {
		no_donation_nag = true,
	},

	misc = {
		-- VRR: 0 off, 1 on, 2 fullscreen only
		vrr = 0,
		middle_click_paste = false,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		-- global default font for fps/notification/config-error text
		font_family = "0xProto Nerd Font Mono",
		-- when DPMS is off, wake monitors on mouse move / key press
		mouse_move_enables_dpms = false,
		key_press_enables_dpms = false,
		-- window swallowing: hide the terminal an app was launched from
		enable_swallow = false,
		animate_manual_resizes = true,
		-- a half-written save must never reach the compositor; reload is on a bind
		disable_autoreload = true,
	},

	debug = {
		overlay = false,
	},

	-- ░▀█▀░█▀█░█▀█░█░█░▀█▀
	-- ░░█░░█░█░█▀▀░█░█░░█░
	-- ░▀▀▀░▀░▀░▀░░░▀▀▀░░▀░

	input = {
		kb_layout = "se,us",
		-- valid models: `localectl list-x11-keymap-models`
		-- toggles: grep 'grp:.*toggle' /usr/share/X11/xkb/rules/base.lst
		kb_options = "grp:shifts_toggle",
		-- 0 disabled, 1 focus on mouseover, 2 focus on click only, 3 no effect
		follow_mouse = 2,
		-- -1.0 to 1.0, 0 means no modification
		sensitivity = 0,

		touchpad = {
			disable_while_typing = true,
			natural_scroll = true,
			tap_to_click = true,
			tap_and_drag = true,
			drag_lock = true,
		},
	},

	binds = {
		workspace_center_on = 1,
	},

	xwayland = {
		force_zero_scaling = true,
	},
})

-- ░█▀▀░█░█░█▀▄░█░█░█▀▀░█▀▀
-- ░█░░░█░█░█▀▄░▀▄▀░█▀▀░▀▀█
-- ░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀
--
-- Inert while animations.enabled is false, kept so flipping that switch works.

hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("smoothOut", { type = "bezier", points = { { 0.5, 0 }, { 0.99, 0.99 } } })
hl.curve("smoothIn", { type = "bezier", points = { { 0.5, -0.5 }, { 0.68, 1.5 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
-- used by rainbow borders and rotating colors
hl.animation({ leaf = "borderangle", enabled = true, speed = 180, bezier = "liner", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smoothOut" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 5, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })

-- ░█▀▄░█▀▀░█░█░▀█▀░█▀▀░█▀▀░█▀▀
-- ░█░█░█▀▀░▀▄▀░░█░░█░░░█▀▀░▀▀█
-- ░▀▀░░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀▀▀

hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })
-- framework13 touchpad
hl.device({ name = "pixa3854:00-093a:0274-touchpad", accel_profile = "adaptive" })
