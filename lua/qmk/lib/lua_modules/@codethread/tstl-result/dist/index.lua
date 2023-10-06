local ____lualib = require("qmk.lib.lualib_bundle")
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local __TS__Unpack = ____lualib.__TS__Unpack
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local __TS__PromiseAll = ____lualib.__TS__PromiseAll
local __TS__Spread = ____lualib.__TS__Spread
local __TS__Class = ____lualib.__TS__Class
local __TS__Promise = ____lualib.__TS__Promise
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local ____exports = {}
local defaultErrorConfig = {withStackTrace = false}
local function createNeverThrowError(message, result, config)
    if config == nil then
        config = defaultErrorConfig
    end
    local data = result:isOk() and ({type = "Ok", value = result.value}) or ({type = "Err", value = result.error})
    local ____config_withStackTrace_0
    if config.withStackTrace then
        ____config_withStackTrace_0 = __TS__New(Error).stack
    else
        ____config_withStackTrace_0 = nil
    end
    local maybeStack = ____config_withStackTrace_0
    return {data = data, message = message, stack = maybeStack}
end
local function appendValueToEndOfList(value)
    return function(list)
        local ____array_1 = __TS__SparseArrayNew(__TS__Unpack(list))
        __TS__SparseArrayPush(____array_1, value)
        return {__TS__SparseArraySpread(____array_1)}
    end
end
--- Short circuits on the FIRST Err value that we find
local function combineResultList(resultList)
    return __TS__ArrayReduce(
        resultList,
        function(____, acc, result) return acc:isOk() and (result:isErr() and ____exports.err(result.error) or acc:map(appendValueToEndOfList(result.value))) or acc end,
        ____exports.ok({})
    )
end
local function combineResultAsyncList(asyncResultList)
    return ____exports.ResultAsync:fromSafePromise(__TS__PromiseAll(asyncResultList)):andThen(combineResultList)
end
--- Give a list of all the errors we find
local function combineResultListWithAllErrors(resultList)
    return __TS__ArrayReduce(
        resultList,
        function(____, acc, result)
            local ____result_isErr_result_6
            if result:isErr() then
                local ____acc_isErr_result_3
                if acc:isErr() then
                    local ____array_2 = __TS__SparseArrayNew(__TS__Unpack(acc.error))
                    __TS__SparseArrayPush(____array_2, result.error)
                    ____acc_isErr_result_3 = ____exports.err({__TS__SparseArraySpread(____array_2)})
                else
                    ____acc_isErr_result_3 = ____exports.err({result.error})
                end
                ____result_isErr_result_6 = ____acc_isErr_result_3
            else
                local ____acc_isErr_result_5
                if acc:isErr() then
                    ____acc_isErr_result_5 = acc
                else
                    local ____array_4 = __TS__SparseArrayNew(__TS__Unpack(acc.value))
                    __TS__SparseArrayPush(____array_4, result.value)
                    ____acc_isErr_result_5 = ____exports.ok({__TS__SparseArraySpread(____array_4)})
                end
                ____result_isErr_result_6 = ____acc_isErr_result_5
            end
            return ____result_isErr_result_6
        end,
        ____exports.ok({})
    )
end
local function combineResultAsyncListWithAllErrors(asyncResultList)
    return ____exports.ResultAsync:fromSafePromise(__TS__PromiseAll(asyncResultList)):andThen(combineResultListWithAllErrors)
end
--- Wraps a function with a try catch, creating a new function with the same
-- arguments but returning `Ok` if successful, `Err` if the function throws
-- 
-- @param fn function to wrap with ok on success or err on failure
-- @param errorFn when an error is thrown, this will wrap the error result if provided
function ____exports.fromThrowable(fn, errorFn)
    return function(...)
        local args = {...}
        do
            local function ____catch(e)
                local ____errorFn_7
                if errorFn then
                    ____errorFn_7 = errorFn(e)
                else
                    ____errorFn_7 = e
                end
                return true, ____exports.err(____errorFn_7)
            end
            local ____try, ____hasReturned, ____returnValue = pcall(function()
                local result = fn(__TS__Spread(args))
                return true, ____exports.ok(result)
            end)
            if not ____try then
                ____hasReturned, ____returnValue = ____catch(____hasReturned)
            end
            if ____hasReturned then
                return ____returnValue
            end
        end
    end
end
function ____exports.combine(resultList)
    return combineResultList(resultList)
end
function ____exports.combineWithAllErrors(resultList)
    return combineResultListWithAllErrors(resultList)
end
____exports.ok = function(value) return __TS__New(____exports.Ok, value) end
____exports.err = function(err) return __TS__New(____exports.Err, err) end
____exports.Ok = __TS__Class()
local Ok = ____exports.Ok
Ok.name = "Ok"
function Ok.prototype.____constructor(self, value)
    self.value = value
end
function Ok.prototype.isOk(self)
    return true
end
function Ok.prototype.isErr(self)
    return not self:isOk()
end
function Ok.prototype.map(self, f)
    return ____exports.ok(f(self.value))
end
function Ok.prototype.mapErr(self, _f)
    return ____exports.ok(self.value)
end
function Ok.prototype.andThen(self, f)
    return f(self.value)
end
function Ok.prototype.orElse(self, _f)
    return ____exports.ok(self.value)
end
function Ok.prototype.asyncAndThen(self, f)
    return f(self.value)
end
function Ok.prototype.asyncMap(self, f)
    return ____exports.ResultAsync:fromSafePromise(f(self.value))
end
function Ok.prototype.unwrapOr(self, _v)
    return self.value
end
function Ok.prototype.match(self, ok, _err)
    return ok(self.value)
end
function Ok.prototype._unsafeUnwrap(self, _)
    return self.value
end
function Ok.prototype._unsafeUnwrapErr(self, config)
    error(
        createNeverThrowError("Called `_unsafeUnwrapErr` on an Ok", self, config),
        0
    )
end
____exports.Err = __TS__Class()
local Err = ____exports.Err
Err.name = "Err"
function Err.prototype.____constructor(self, ____error)
    self.error = ____error
end
function Err.prototype.isOk(self)
    return false
end
function Err.prototype.isErr(self)
    return not self:isOk()
end
function Err.prototype.map(self, _f)
    return ____exports.err(self.error)
end
function Err.prototype.mapErr(self, f)
    return ____exports.err(f(self.error))
end
function Err.prototype.andThen(self, _f)
    return ____exports.err(self.error)
end
function Err.prototype.orElse(self, f)
    return f(self.error)
end
function Err.prototype.asyncAndThen(self, _f)
    return ____exports.errAsync(self.error)
end
function Err.prototype.asyncMap(self, _f)
    return ____exports.errAsync(self.error)
end
function Err.prototype.unwrapOr(self, v)
    return v
end
function Err.prototype.match(self, _ok, err)
    return err(self.error)
end
function Err.prototype._unsafeUnwrap(self, config)
    error(
        createNeverThrowError("Called `_unsafeUnwrap` on an Err", self, config),
        0
    )
end
function Err.prototype._unsafeUnwrapErr(self, _)
    return self.error
end
____exports.ResultAsync = __TS__Class()
local ResultAsync = ____exports.ResultAsync
ResultAsync.name = "ResultAsync"
function ResultAsync.prototype.____constructor(self, res)
    self._promise = res
end
function ResultAsync.fromSafePromise(self, promise)
    local newPromise = promise["then"](
        promise,
        function(____, value) return __TS__New(____exports.Ok, value) end
    )
    return __TS__New(____exports.ResultAsync, newPromise)
end
function ResultAsync.fromPromise(self, promise, errorFn)
    local newPromise = promise["then"](
        promise,
        function(____, value) return __TS__New(____exports.Ok, value) end
    ):catch(function(____, e) return __TS__New(
        ____exports.Err,
        errorFn(e)
    ) end)
    return __TS__New(____exports.ResultAsync, newPromise)
end
function ResultAsync.combine(self, asyncResultList)
    return combineResultAsyncList(asyncResultList)
end
function ResultAsync.combineWithAllErrors(self, asyncResultList)
    return combineResultAsyncListWithAllErrors(asyncResultList)
end
function ResultAsync.prototype.map(self, f)
    local ____exports_ResultAsync_9 = ____exports.ResultAsync
    local ____self_8 = self._promise
    return __TS__New(
        ____exports_ResultAsync_9,
        ____self_8["then"](
            ____self_8,
            function(____, res)
                return __TS__AsyncAwaiter(function(____awaiter_resolve)
                    if res:isErr() then
                        return ____awaiter_resolve(
                            nil,
                            __TS__New(____exports.Err, res.error)
                        )
                    end
                    return ____awaiter_resolve(
                        nil,
                        __TS__New(
                            ____exports.Ok,
                            __TS__Await(f(res.value))
                        )
                    )
                end)
            end
        )
    )
end
function ResultAsync.prototype.mapErr(self, f)
    local ____exports_ResultAsync_11 = ____exports.ResultAsync
    local ____self_10 = self._promise
    return __TS__New(
        ____exports_ResultAsync_11,
        ____self_10["then"](
            ____self_10,
            function(____, res)
                return __TS__AsyncAwaiter(function(____awaiter_resolve)
                    if res:isOk() then
                        return ____awaiter_resolve(
                            nil,
                            __TS__New(____exports.Ok, res.value)
                        )
                    end
                    return ____awaiter_resolve(
                        nil,
                        __TS__New(
                            ____exports.Err,
                            __TS__Await(f(res.error))
                        )
                    )
                end)
            end
        )
    )
end
function ResultAsync.prototype.andThen(self, f)
    local ____exports_ResultAsync_13 = ____exports.ResultAsync
    local ____self_12 = self._promise
    return __TS__New(
        ____exports_ResultAsync_13,
        ____self_12["then"](
            ____self_12,
            function(____, res)
                if res:isErr() then
                    return __TS__New(____exports.Err, res.error)
                end
                local newValue = f(res.value)
                return __TS__InstanceOf(newValue, ____exports.ResultAsync) and newValue._promise or newValue
            end
        )
    )
end
function ResultAsync.prototype.orElse(self, f)
    local ____exports_ResultAsync_15 = ____exports.ResultAsync
    local ____self_14 = self._promise
    return __TS__New(
        ____exports_ResultAsync_15,
        ____self_14["then"](
            ____self_14,
            function(____, res)
                return __TS__AsyncAwaiter(function(____awaiter_resolve)
                    if res:isErr() then
                        return ____awaiter_resolve(
                            nil,
                            f(res.error)
                        )
                    end
                    return ____awaiter_resolve(
                        nil,
                        __TS__New(____exports.Ok, res.value)
                    )
                end)
            end
        )
    )
end
function ResultAsync.prototype.match(self, ok, _err)
    local ____self_16 = self._promise
    return ____self_16["then"](
        ____self_16,
        function(____, res) return res:match(ok, _err) end
    )
end
function ResultAsync.prototype.unwrapOr(self, t)
    local ____self_17 = self._promise
    return ____self_17["then"](
        ____self_17,
        function(____, res) return res:unwrapOr(t) end
    )
end
ResultAsync.prototype["then"] = function(self, successCallback, failureCallback)
    local ____self_18 = self._promise
    return ____self_18["then"](____self_18, successCallback, failureCallback)
end
____exports.okAsync = function(value) return __TS__New(
    ____exports.ResultAsync,
    __TS__Promise.resolve(__TS__New(____exports.Ok, value))
) end
____exports.errAsync = function(err) return __TS__New(
    ____exports.ResultAsync,
    __TS__Promise.resolve(__TS__New(____exports.Err, err))
) end
____exports.fromPromise = ____exports.ResultAsync.fromPromise
____exports.fromSafePromise = ____exports.ResultAsync.fromSafePromise
return ____exports
