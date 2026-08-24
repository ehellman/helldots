-- Docking profiles for draupnir.
--
-- A profile is picked automatically: the first one whose `requires` outputs are
-- all connected wins, so `laptop-only` must stay last. Where two profiles
-- describe the same hardware on different ports, auto-detect cannot tell them
-- apart — use the cycle bind (SUPER + SHIFT + P) or set HYPR_MONITOR_PROFILE
-- before launching Hyprland.
--
-- TODO: `requires` matches an output name or a substring of the monitor
-- description. Descriptions survive replugging into a different port, names do
-- not, so replace each name below with a description the next time that dock is
-- in reach: hyprctl monitors -j | jq -r '.[] | .name + " = " + .description'

---@type HL.MonitorSpec
local laptop = { output = "eDP-1", mode = "2880x1920@120.0", scale = 1.5, vrr = 1, bitdepth = 8 }

---@param position string
---@param overrides? table
---@return HL.MonitorSpec
local function laptop_at(position, overrides)
    ---@type table<string, any>
    local spec = { position = position }
    for k, v in pairs(laptop) do
        spec[k] = v
    end
    for k, v in pairs(overrides or {}) do
        spec[k] = v
    end
    return spec
end

return {
    {
        name = "lg-c2-left",
        requires = { "DP-2" },
        monitors = {
            laptop_at("0x0", { cm = "auto" }),
            { output = "DP-2", mode = "3840x2160@120.0", position = "1920x0", scale = 1, vrr = 0, bitdepth = 8, cm = "auto" },
        },
    },
    {
        name = "lg-c2-below",
        requires = { "DP-3" },
        monitors = {
            laptop_at("0x2160"),
            { output = "DP-3", mode = "3840x2160@120.0", position = "0x0", scale = 1, vrr = 0, bitdepth = 8 },
        },
    },
    {
        -- Same port as lg-c2-below, so auto-detect will never reach this one.
        -- Select it explicitly until both monitors have descriptions here.
        name = "stadium-single",
        requires = { "DP-3" },
        monitors = {
            laptop_at("0x1080"),
            { output = "DP-3", mode = "1920x1080@60.0", position = "0x0", scale = 1, vrr = 0, bitdepth = 8 },
        },
    },
    {
        name = "stadium-dual",
        requires = { "DP-9", "DP-10" },
        monitors = {
            laptop_at("0x1080"),
            { output = "DP-9", mode = "1920x1080@60.0", position = "0x0", scale = 1, vrr = 0, bitdepth = 8 },
            { output = "DP-10", mode = "1920x1080@60.0", position = "1920x0", scale = 1, vrr = 0, bitdepth = 8 },
        },
    },
    {
        name = "avensia-office",
        requires = { "DP-10", "DP-11" },
        monitors = {
            laptop_at("0x1440"),
            { output = "DP-10", mode = "2560x1440@60.0", position = "0x0", scale = 1, vrr = 0, bitdepth = 8 },
            { output = "DP-11", mode = "2560x1440@60.0", position = "2560x0", scale = 1, vrr = 0, bitdepth = 8, transform = 3 },
        },
    },
    {
        name = "laptop-only",
        requires = {},
        monitors = { laptop_at("0x0") },
    },
}
