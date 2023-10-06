local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__Symbol = ____lualib.__TS__Symbol
local Symbol = ____lualib.Symbol
local ____exports = {}
local symbol = __TS__Symbol("brand")
--- Brands the output type of a schema.
-- 
-- @param schema The scheme to be branded.
-- @param brand The brand name.
-- @returns The branded schema.
function ____exports.brand(schema, name)
    return schema
end
return ____exports
