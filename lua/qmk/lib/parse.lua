local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local ____exports = {}
local v = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.index")
local userConfigRequiredSchema = v.object({
    name = v.string(),
    layout = v.array(
        v.string(
            "Layout rows must be strings",
            {
                v.minLength(1, "Layout rows must not be empty"),
                v.custom(
                    function(row) return not __TS__StringStartsWith(row, " ") and not __TS__StringEndsWith(row, " ") end,
                    "no leading or trailing whitespace"
                )
            }
        ),
        "please pass a layout",
        {v.minLength(1, "Layout must not be empty")}
    )
})
local userConfigOptionalSchema = v.partial(v.object({
    variant = v.enumType({"qmk", "zmk"}),
    timeout = v.number({v.minValue(1)}),
    auto_format_pattern = v.string(),
    comment_preview = v.partial(v.object({
        position = v.enumType({"top", "bottom", "inside", "none"}),
        keymap_overrides = v.record(
            v.string(),
            v.string()
        ),
        symbols = v.partial(v.object({
            space = v.string(),
            horz = v.string(),
            vert = v.string(),
            tl = v.string(),
            tm = v.string(),
            tr = v.string(),
            ml = v.string(),
            mm = v.string(),
            mr = v.string(),
            bl = v.string(),
            bm = v.string(),
            br = v.string()
        }))
    }))
}))
local userConfigSchema = v.strict(v.merge({userConfigRequiredSchema, userConfigOptionalSchema}, "Please pass a config table"))
function ____exports.parse(user_config)
    local conf = v.safeParse(userConfigSchema, user_config)
    if conf:isErr() then
        vim.print(conf.error)
        local s = v.flatten(conf.error)
        error(s, 0)
    end
    return conf.value
end
return ____exports
