local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
function ____exports.squer(str)
    return table.concat(
        __TS__ArrayMap(
            __TS__StringSplit(str, ""),
            function(____, l, i) return i % 2 == 0 and l or string.upper(l) end
        ),
        ""
    )
end
return ____exports
