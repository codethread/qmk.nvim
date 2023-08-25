local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__PromiseAll = ____lualib.__TS__PromiseAll
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipeAsync = ____index.executePipeAsync
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPath = ____index.getPath
local getPathInfo = ____index.getPathInfo
local getPipeInfo = ____index.getPipeInfo
--- Creates an async tuple schema.
-- 
-- @param items The items schema.
-- @param pipe A validation and transformation pipe.
-- @returns An async tuple schema.
-- @param items The items schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An async tuple schema.
-- @param items The items schema.
-- @param rest The rest schema.
-- @param pipe A validation and transformation pipe.
-- @returns An async tuple schema.
-- @param items The items schema.
-- @param rest The rest schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An async tuple schema.
function ____exports.tupleAsync(items, arg2, arg3, arg4)
    local ____temp_0 = type(arg2) == "table" and not __TS__ArrayIsArray(arg2) and __TS__ObjectAssign(
        {rest = arg2},
        getErrorAndPipe(arg3, arg4)
    ) or getErrorAndPipe(arg2, arg3)
    local rest = ____temp_0.rest
    local ____error = ____temp_0.error
    local pipe = ____temp_0.pipe
    return {
        schema = "tuple",
        tuple = {items = items, rest = rest},
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                if not __TS__ArrayIsArray(input) or not rest and #items ~= #input or rest and #items > #input then
                    return ____awaiter_resolve(
                        nil,
                        {issues = {getIssue(info, {reason = "type", validation = "tuple", message = ____error or "Invalid type, expected tuple", input = input})}}
                    )
                end
                local issues
                local output = {}
                __TS__Await(__TS__PromiseAll({
                    __TS__PromiseAll(__TS__ArrayMap(
                        items,
                        function(____, schema, index)
                            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                                if not (info and info.abortEarly and issues) then
                                    local value = input[index + 1]
                                    local result = __TS__Await(schema:_parse(
                                        value,
                                        getPathInfo(
                                            info,
                                            getPath(info and info.path, {schema = "tuple", input = input, key = index, value = value})
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
                                            output[index + 1] = result.output
                                        end
                                    end
                                end
                            end)
                        end
                    )),
                    rest and __TS__PromiseAll(__TS__ArrayMap(
                        __TS__ArraySlice(input, #items),
                        function(____, value, index)
                            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                                if not (info and info.abortEarly and issues) then
                                    local tupleIndex = #items + index
                                    local result = __TS__Await(rest:_parse(
                                        value,
                                        getPathInfo(
                                            info,
                                            getPath(info and info.path, {schema = "tuple", input = input, key = tupleIndex, value = value})
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
                                            output[tupleIndex + 1] = result.output
                                        end
                                    end
                                end
                            end)
                        end
                    ))
                }):catch(function() return nil end))
                return ____awaiter_resolve(
                    nil,
                    issues and ({issues = issues}) or executePipeAsync(
                        output,
                        pipe,
                        getPipeInfo(info, "tuple")
                    )
                )
            end)
        end
    }
end
return ____exports
