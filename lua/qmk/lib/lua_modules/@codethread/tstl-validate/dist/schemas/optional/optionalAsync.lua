local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
--- Creates an async optional schema.
-- 
-- @param wrapped The wrapped schema.
-- @returns An async optional schema.
function ____exports.optionalAsync(wrapped)
    return {
        schema = "optional",
        wrapped = wrapped,
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                if input == nil then
                    return ____awaiter_resolve(nil, {output = input})
                end
                return ____awaiter_resolve(
                    nil,
                    wrapped:_parse(input, info)
                )
            end)
        end
    }
end
return ____exports
