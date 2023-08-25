local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.schemas.index")
local object = ____index.object
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getErrorAndPipe = ____index.getErrorAndPipe
--- Creates an object schema that contains only the selected keys of an existing
-- schema.
-- 
-- @param schema The schema to pick from.
-- @param keys The selected keys
-- @param pipe A validation and transformation pipe.
-- @returns An object schema.
-- @param schema The schema to pick from.
-- @param keys The selected keys
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An object schema.
function ____exports.pick(schema, keys, arg3, arg4)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg3, arg4)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    return object(
        __TS__ArrayReduce(
            __TS__ObjectEntries(schema.object),
            function(____, object, ____bindingPattern0)
                local schema
                local key
                key = ____bindingPattern0[1]
                schema = ____bindingPattern0[2]
                return __TS__ArrayIncludes(keys, key) and __TS__ObjectAssign({}, object, {[key] = schema}) or object
            end,
            {}
        ),
        ____error,
        pipe
    )
end
return ____exports
