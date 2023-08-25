--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Executes the validation and transformation pipe.
-- 
-- @param input The input value.
-- @param pipe The pipe to be executed.
-- @param info The validation info.
-- @returns The output value.
function ____exports.executePipe(input, pipe, info)
    local issues
    local output = input
    for ____, action in ipairs(pipe) do
        local result = action(output, info)
        if result.issues then
            if issues then
                for ____, issue in ipairs(result.issues) do
                    issues[#issues + 1] = issue
                end
            else
                issues = result.issues
            end
            if info.abortEarly or info.abortPipeEarly then
                break
            end
        else
            output = result.output
        end
    end
    return issues and ({issues = issues}) or ({output = output})
end
return ____exports
