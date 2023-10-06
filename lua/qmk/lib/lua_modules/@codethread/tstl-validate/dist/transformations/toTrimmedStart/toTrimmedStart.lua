local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__StringTrimStart = ____lualib.__TS__StringTrimStart
local ____exports = {}
--- Creates a transformation function that removes the leading white space and
-- line terminator characters from a string.
-- 
-- @returns A transformation function.
function ____exports.toTrimmedStart()
    return function(input) return {output = __TS__StringTrimStart(input)} end
end
return ____exports
