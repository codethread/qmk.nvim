local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayJoin = ____lualib.__TS__ArrayJoin
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local ____exports = {}
--- Flatten the error messages of a Vali error.
-- Flatten the error messages of issues.
-- 
-- @param error A Vali error.
-- @returns Flat errors.
-- @param issues The issues.
-- @returns Flat errors.
function ____exports.flatten(arg1)
    return __TS__ArrayReduce(
        __TS__ArrayIsArray(arg1) and arg1 or arg1.issues,
        function(____, flatErrors, issue)
            if issue.path then
                local path = __TS__ArrayJoin(
                    __TS__ArrayMap(
                        issue.path,
                        function(____, ____bindingPattern0)
                            local key
                            key = ____bindingPattern0.key
                            return key
                        end
                    ),
                    "."
                )
                local ____flatErrors_nested_1 = flatErrors.nested
                local ____array_0 = __TS__SparseArrayNew(unpack(flatErrors.nested[path] or ({})))
                __TS__SparseArrayPush(____array_0, issue.message)
                ____flatErrors_nested_1[path] = {__TS__SparseArraySpread(____array_0)}
            else
                local ____flatErrors_3 = flatErrors
                local ____array_2 = __TS__SparseArrayNew(unpack(flatErrors.root or ({})))
                __TS__SparseArrayPush(____array_2, issue.message)
                ____flatErrors_3.root = {__TS__SparseArraySpread(____array_2)}
            end
            return flatErrors
        end,
        {nested = {}}
    )
end
return ____exports
