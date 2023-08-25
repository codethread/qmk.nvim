local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.schemas.index")
local objectAsync = ____index.objectAsync
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getErrorAndPipe = ____index.getErrorAndPipe
--- Creates an async object schema that contains only the selected keys of an
-- existing schema.
-- 
-- @param schema The schema to omit from.
-- @param keys The selected keys
-- @param pipe A validation and transformation pipe.
-- @returns An async object schema.
-- @param schema The schema to omit from.
-- @param keys The selected keys
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An async object schema.
function ____exports.omitAsync(schema, keys, arg3, arg4)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg3, arg4)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    return objectAsync(
        __TS__ArrayReduce(
            __TS__ObjectEntries(schema.object),
            function(____, object, ____bindingPattern0)
                local schema
                local key
                key = ____bindingPattern0[1]
                schema = ____bindingPattern0[2]
                return __TS__ArrayIncludes(keys, key) and object or __TS__ObjectAssign({}, object, {[key] = schema})
            end,
            {}
        ),
        ____error,
        pipe
    )
end
return ____exports
