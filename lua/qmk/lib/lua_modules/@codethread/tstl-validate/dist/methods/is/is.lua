--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Checks if the input matches the scheme. By using a type predicate, this
-- function can be used as a type guard.
-- 
-- @param schema The schema to be used.
-- @param input The input to be tested.
-- @returns Whether the input matches the scheme.
function ____exports.is(schema, input)
    return not schema:_parse(input, {abortEarly = true}).issues
end
return ____exports
