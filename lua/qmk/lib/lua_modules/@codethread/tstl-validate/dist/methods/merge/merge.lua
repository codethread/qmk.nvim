local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.schemas.index")
local object = ____index.object
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getErrorAndPipe = ____index.getErrorAndPipe
--- Merges multiple object schemas into a single one. Subsequent object schemas
-- overwrite the previous ones.
-- 
-- @param schemas The schemas to be merged.
-- @param pipe A validation and transformation pipe.
-- @returns An object schema.
-- @param schemas The schemas to be merged.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An object schema.
function ____exports.merge(schemas, arg2, arg3)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg2, arg3)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    return object(
        __TS__ArrayReduce(
            schemas,
            function(____, object, schemas) return __TS__ObjectAssign({}, object, schemas.object) end,
            {}
        ),
        ____error,
        pipe
    )
end
return ____exports
