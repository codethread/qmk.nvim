local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
--- Executes the async validation and transformation pipe.
-- 
-- @param input The input value.
-- @param pipe The pipe to be executed.
-- @param info The validation info.
-- @returns The output value.
function ____exports.executePipeAsync(input, pipe, info)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local output = input
        local issues
        for ____, action in ipairs(pipe) do
            local result = __TS__Await(action(output, info))
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
        return ____awaiter_resolve(nil, issues and ({issues = issues}) or ({output = output}))
    end)
end
return ____exports
