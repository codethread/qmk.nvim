local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__StringTrimEnd = ____lualib.__TS__StringTrimEnd
local ____exports = {}
--- Creates a transformation function that removes the trailing white space and
-- line terminator characters from a string.
-- 
-- @returns A transformation function.
function ____exports.toTrimmedEnd()
    return function(input) return {output = __TS__StringTrimEnd(input)} end
end
return ____exports
