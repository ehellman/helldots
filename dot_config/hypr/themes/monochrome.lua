-- Monochrome / Vercel-style palette

return require("themes/palette").new({
    -- Background scale
    base = "000000",
    mantle = "0a0a0a",
    crust = "050505",
    surface0 = "171717",
    surface1 = "222222",
    surface2 = "333333",

    -- Foreground scale
    text = "ffffff",
    subtext1 = "ededed",
    subtext0 = "a1a1a1",
    overlay2 = "888888",
    overlay1 = "666666",
    overlay0 = "444444",

    -- Semantic colors
    red = "ef4444",
    green = "22c55e",
    yellow = "eab308",
    blue = "3b82f6",

    -- Aliases for compatibility with mocha names
    rosewater = "ffffff",
    flamingo = "ededed",
    pink = "a1a1a1",
    mauve = "888888",
    maroon = "ef4444",
    peach = "eab308",
    teal = "22c55e",
    sky = "a1a1a1",
    sapphire = "3b82f6",
    lavender = "ffffff",
})
