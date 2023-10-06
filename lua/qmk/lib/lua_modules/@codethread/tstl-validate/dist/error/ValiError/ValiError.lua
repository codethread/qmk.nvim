local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
--- A Valibot error with useful information.
____exports.ValiError = __TS__Class()
local ValiError = ____exports.ValiError
ValiError.name = "ValiError"
__TS__ClassExtends(ValiError, Error)
function ValiError.prototype.____constructor(self, issues)
    Error.prototype.____constructor(self, issues[1].message)
    self.name = "ValiError"
    self.issues = issues
end
return ____exports
