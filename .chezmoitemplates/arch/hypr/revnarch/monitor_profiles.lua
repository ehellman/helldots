-- revnarch is a desktop with fixed outputs, so there is only ever one profile.
-- The selection machinery in conf/monitors.lua still runs; it just always lands
-- here.

return {
    {
        name = "desk",
        requires = {},
        monitors = {
            -- LG C2, HDR + wide gamut
            {
                output = "HDMI-A-2",
                mode = "3840x2160@119.88",
                position = "0x0",
                scale = 1,
                vrr = 0,
                bitdepth = 10,
                supports_wide_color = 1,
                supports_hdr = 1,
                cm = "wide",
            },
            -- ultrawide, below the LG
            {
                output = "HDMI-A-1",
                mode = "3840x1100@60.0",
                position = "0x2160",
                scale = "auto",
                vrr = 0,
                bitdepth = 8,
            },
            -- jetkvm, mirrors the LG
            {
                output = "HDMI-A-3",
                mode = "preferred",
                position = "auto",
                scale = "auto",
                mirror = "HDMI-A-2",
            },
        },
    },
}
