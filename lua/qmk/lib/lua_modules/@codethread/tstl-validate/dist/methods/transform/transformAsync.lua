local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- Adds an async transformation step to a schema, which is executed at the end
-- of parsing and can change the output type.
-- 
-- @param schema The schema to be used.
-- @param action The transformation action.
-- @returns A transformed schema.
function ____exports.transformAsync(schema, action)
    return __TS__ObjectAssign(
        {},
        schema,
        {
            async = true,
            _parse = function(self, input, info)
                return __TS__AsyncAwaiter(function(____awaiter_resolve)
                    local result = __TS__Await(schema:_parse(input, info))
                    return ____awaiter_resolve(
                        nil,
                        result.issues and result or ({output = __TS__Await(action(result.output))})
                    )
                end)
            end
        }
    )
end
return ____exports
