local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipeAsync = ____index.executePipeAsync
local getPipeInfo = ____index.getPipeInfo
--- Creates an async any schema.
-- 
-- @param pipe A validation and transformation pipe.
-- @returns An async any schema.
function ____exports.anyAsync(pipe)
    if pipe == nil then
        pipe = {}
    end
    return {
        schema = "any",
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                return ____awaiter_resolve(
                    nil,
                    executePipeAsync(
                        input,
                        pipe,
                        getPipeInfo(info, "any")
                    )
                )
            end)
        end
    }
end
return ____exports
