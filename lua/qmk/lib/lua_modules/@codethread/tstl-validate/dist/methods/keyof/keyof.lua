local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.schemas.index")
local enumType = ____index.enumType
--- Creates a enum schema of object keys.
-- 
-- @param schema The object schema.
-- @returns A enum schema.
function ____exports.keyof(schema)
    return enumType(__TS__ObjectKeys(schema.object))
end
return ____exports
