--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____tstl_2Dresult = require("qmk.lib.lua_modules.@codethread.tstl-result.dist.index")
local err = ____tstl_2Dresult.err
local ok = ____tstl_2Dresult.ok
--- Parses unknown input based on a schema.
-- 
-- @param schema The schema to be used.
-- @param input The input to be parsed.
-- @param info The optional parse info.
-- @returns The parsed output.
function ____exports.safeParse(schema, input, info)
    local result = schema:_parse(input, info)
    return result.issues and err(result.issues) or ok(result.output)
end
return ____exports
