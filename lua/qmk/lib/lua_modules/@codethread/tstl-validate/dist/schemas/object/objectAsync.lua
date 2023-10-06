local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__PromiseAll = ____lualib.__TS__PromiseAll
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipeAsync = ____index.executePipeAsync
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPath = ____index.getPath
local getPathInfo = ____index.getPathInfo
local getPipeInfo = ____index.getPipeInfo
--- Creates an async object schema.
-- 
-- @param object The object schema.
-- @param pipe A validation and transformation pipe.
-- @returns An async object schema.
-- @param object The object schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An async object schema.
function ____exports.objectAsync(object, arg2, arg3)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg2, arg3)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    local cachedEntries
    return {
        schema = "object",
        object = object,
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                if not input or type(input) ~= "table" or __TS__ArrayIsArray(input) then
                    return ____awaiter_resolve(
                        nil,
                        {issues = {getIssue(info, {reason = "type", validation = "object", message = ____error or "Invalid type", input = input})}}
                    )
                end
                cachedEntries = cachedEntries or __TS__ObjectEntries(object)
                local issues
                local output = {}
                __TS__Await(__TS__PromiseAll(__TS__ArrayMap(
                    cachedEntries,
                    function(____, objectEntry)
                        return __TS__AsyncAwaiter(function(____awaiter_resolve)
                            if not (info and info.abortEarly and issues) then
                                local key = objectEntry[1]
                                local value = input[key]
                                local result = __TS__Await(objectEntry[2]:_parse(
                                    value,
                                    getPathInfo(
                                        info,
                                        getPath(info and info.path, {schema = "object", input = input, key = key, value = value})
                                    )
                                ))
                                if not (info and info.abortEarly and issues) then
                                    if result.issues then
                                        if issues then
                                            for ____, issue in ipairs(result.issues) do
                                                issues[#issues + 1] = issue
                                            end
                                        else
                                            issues = result.issues
                                        end
                                        if info and info.abortEarly then
                                            error(nil, 0)
                                        end
                                    else
                                        output[key] = result.output
                                    end
                                end
                            end
                        end)
                    end
                )):catch(function() return nil end))
                return ____awaiter_resolve(
                    nil,
                    issues and ({issues = issues}) or executePipeAsync(
                        output,
                        pipe,
                        getPipeInfo(info, "object")
                    )
                )
            end)
        end
    }
end
return ____exports
