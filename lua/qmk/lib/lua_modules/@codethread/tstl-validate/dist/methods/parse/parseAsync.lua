local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.error.index")
local ValiError = ____index.ValiError
--- Parses unknown input based on a schema.
-- 
-- @param schema The schema to be used.
-- @param input The input to be parsed.
-- @param info The optional parse info.
-- @returns The parsed output.
function ____exports.parseAsync(schema, input, info)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local result = __TS__Await(schema:_parse(input, info))
        if result.issues then
            error(
                __TS__New(ValiError, result.issues),
                0
            )
        end
        return ____awaiter_resolve(nil, result.output)
    end)
end
return ____exports
