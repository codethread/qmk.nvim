--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipe = ____index.executePipe
local getPipeInfo = ____index.getPipeInfo
--- Creates a any schema.
-- 
-- @param pipe A validation and transformation pipe.
-- @returns A any schema.
function ____exports.any(pipe)
    if pipe == nil then
        pipe = {}
    end
    return {
        schema = "any",
        async = false,
        _parse = function(self, input, info)
            return executePipe(
                input,
                pipe,
                getPipeInfo(info, "any")
            )
        end
    }
end
return ____exports
