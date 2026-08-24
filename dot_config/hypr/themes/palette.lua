-- Wraps a table of bare hex strings with the color accessors Hyprland wants.
--
-- hyprlang needed a `$fooAlpha` twin for every color so it could concatenate
-- rgba() strings by hand. Lua does not: the palette stores hex once and builds
-- whatever form the call site needs.

local M = {}

---@param hex table<string, string> bare six-digit hex, no prefix
function M.new(hex)
    local theme = { hex = hex }

    ---@param name string
    ---@return string
    function theme.rgb(name)
        local value = hex[name]
        assert(value, "unknown color: " .. name)
        return "rgb(" .. value .. ")"
    end

    ---@param name string
    ---@param alpha string two hex digits, e.g. "80"
    ---@return string
    function theme.rgba(name, alpha)
        local value = hex[name]
        assert(value, "unknown color: " .. name)
        return "rgba(" .. value .. alpha .. ")"
    end

    return theme
end

return M
