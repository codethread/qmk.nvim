local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- Coerces the input of a async schema to match the required type.
-- 
-- @param schema The affected schema.
-- @param action The coerceation action.
-- @returns The passed schema.
function ____exports.coerceAsync(schema, action)
    return __TS__ObjectAssign(
        {},
        schema,
        {_parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                return ____awaiter_resolve(
                    nil,
                    schema:_parse(
                        __TS__Await(action(input)),
                        info
                    )
                )
            end)
        end}
    )
end
return ____exports
