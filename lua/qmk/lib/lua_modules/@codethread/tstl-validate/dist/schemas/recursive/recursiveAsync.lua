local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
--- Creates an async recursive schema.
-- 
-- @param getter The schema getter.
-- @returns An async recursive schema.
function ____exports.recursiveAsync(getter)
    return {
        schema = "recursive",
        getter = getter,
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                return ____awaiter_resolve(
                    nil,
                    getter():_parse(input, info)
                )
            end)
        end
    }
end
return ____exports
