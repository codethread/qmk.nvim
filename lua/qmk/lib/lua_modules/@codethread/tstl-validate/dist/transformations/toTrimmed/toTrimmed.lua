local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
--- Creates a transformation function that removes the leading and trailing
-- white space and line terminator characters from a string.
-- 
-- @returns A transformation function.
function ____exports.toTrimmed()
    return function(input) return {output = __TS__StringTrim(input)} end
end
return ____exports
