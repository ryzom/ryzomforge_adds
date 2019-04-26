-- misc
--
if misc == nil then
    misc = {}
end

-- convert CRGBA to hexadecimal 6-digits
function misc:toHexRGBA(rgba)
    return string.format("%.2x%.2x%.2x%.2x", rgba.R, rgba.G, rgba.B, rgba.A)
end

-- convert hexadecimal to its short-hand version
function misc:toHexShort(hex)
    local s = ''
    for i = 1, #str, 2 do s = s..string.sub(hex:lower(), i, i) end
    return s
end

-- ready to use colored chat string
function misc:encodeColorTag(hex, str)
    return "@{"..self:toHexShort(hex).."}"..str
end

-- setDbRGBA(prop)
-- setDbRGBA(prop, rgba)
-- CRGBA()