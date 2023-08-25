local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipe = ____index.executePipe
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPath = ____index.getPath
local getPathInfo = ____index.getPathInfo
local getPipeInfo = ____index.getPipeInfo
--- Creates a tuple schema.
-- 
-- @param items The items schema.
-- @param pipe A validation and transformation pipe.
-- @returns A tuple schema.
-- @param items The items schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns A tuple schema.
-- @param items The items schema.
-- @param rest The rest schema.
-- @param pipe A validation and transformation pipe.
-- @returns A tuple schema.
-- @param items The items schema.
-- @param rest The rest schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns A tuple schema.
function ____exports.tuple(items, arg2, arg3, arg4)
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
        async = false,
        _parse = function(self, input, info)
            if not __TS__ArrayIsArray(input) or not rest and #items ~= #input or rest and #items > #input then
                return {issues = {getIssue(info, {reason = "type", validation = "tuple", message = ____error or "Invalid type, expected tuple", input = input})}}
            end
            local issues
            local output = {}
            do
                local index = 0
                while index < #items do
                    local value = input[index + 1]
                    local result = items[index + 1]:_parse(
                        value,
                        getPathInfo(
                            info,
                            getPath(info and info.path, {schema = "tuple", input = input, key = index, value = value})
                        )
                    )
                    if result.issues then
                        if issues then
                            for ____, issue in ipairs(result.issues) do
                                issues[#issues + 1] = issue
                            end
                        else
                            issues = result.issues
                        end
                        if info and info.abortEarly then
                            break
                        end
                    else
                        output[index + 1] = result.output
                    end
                    index = index + 1
                end
            end
            if rest then
                do
                    local index = #items
                    while index < #input do
                        local value = input[index + 1]
                        local result = rest:_parse(
                            value,
                            getPathInfo(
                                info,
                                getPath(info and info.path, {schema = "tuple", input = input, key = index, value = value})
                            )
                        )
                        if result.issues then
                            if issues then
                                for ____, issue in ipairs(result.issues) do
                                    issues[#issues + 1] = issue
                                end
                            else
                                issues = result.issues
                            end
                            if info and info.abortEarly then
                                break
                            end
                        else
                            output[index + 1] = result.output
                        end
                        index = index + 1
                    end
                end
            end
            return issues and ({issues = issues}) or executePipe(
                output,
                pipe,
                getPipeInfo(info, "tuple")
            )
        end
    }
end
return ____exports
