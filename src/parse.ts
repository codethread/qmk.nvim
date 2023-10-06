import * as v from "@codethread/tstl-validate";

const userConfigRequiredSchema = v.object({
  name: v.string(),
  layout: v.array(
    v.string("Layout rows must be strings", [
      v.minLength(1, "Layout rows must not be empty"),
      v.custom(
        (row) => !row.startsWith(" ") && !row.endsWith(" "),
        "no leading or trailing whitespace",
      ),
    ]),
    "please pass a layout",
    [v.minLength(1, "Layout must not be empty")],
  ),
});

const userConfigOptionalSchema = v.partial(
  v.object({
    variant: v.enumType(["qmk", "zmk"]),
    timeout: v.number([v.minValue(1)]),
    auto_format_pattern: v.string(),
    comment_preview: v.partial(
      v.object({
        position: v.enumType(["top", "bottom", "inside", "none"]),
        /**
         * table of keymap overrides, e.g { KC_ESC = 'Esc' }
         */
        keymap_overrides: v.record(v.string(), v.string()),
        symbols: v.partial(
          v.object({
            space: v.string(),
            horz: v.string(),
            vert: v.string(),
            tl: v.string(),
            tm: v.string(),
            tr: v.string(),
            ml: v.string(),
            mm: v.string(),
            mr: v.string(),
            bl: v.string(),
            bm: v.string(),
            br: v.string(),
          }),
        ),
      }),
    ),
  }),
);

const userConfigSchema = v.strict(
  v.merge(
    [userConfigRequiredSchema, userConfigOptionalSchema],
    "Please pass a config table",
  ),
);

// type UserConfig = v.Input<typeof userConfigSchema>;
// let s: UserConfig = {
//  comment_preview_schema: {
//     keymap_overrides: {
//       KC_ESC: "Esc",
//     }
//   }
// }
//

export function parse(user_config: unknown) {
  const conf = v.safeParse(userConfigSchema, user_config);
  if (conf.isErr()) {
    vim.print(conf.error);
    const s = v.flatten(conf.error);
    throw s;
    // throw conf.error.map((e) => e.message).join("\n");
  }
  return conf.value;
}
