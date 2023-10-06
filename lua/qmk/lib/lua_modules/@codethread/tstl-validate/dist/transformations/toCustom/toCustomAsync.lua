local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
--- Creates a async custom transformation function.
-- 
-- @param action The transform action.
-- @returns A async transformation function.
function ____exports.toCustomAsync(action)
    return function(input) return __TS__AsyncAwaiter(function(____awaiter_resolve)
        return ____awaiter_resolve(
            nil,
            {output = __TS__Await(action(input))}
        )
    end) end
end
return ____exports
