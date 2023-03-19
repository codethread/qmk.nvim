# qmk.nvim

**qmk.nvim** is a 100% lua plugin for Neovim that formats [QMK](https://docs.qmk.fm/#/newbs) keymaps, used in a large number of mechanical and hobbyist keyboards.

![qmk](https://user-images.githubusercontent.com/10004500/226140459-6a37f7c9-1154-4a7c-899a-5fa6943e6002.gif)

## Features

- automatically align your keymaps
- create a comment string of your keymap

## Requirements

- Neovim >= 0.7
- Treesitter `c` parser available (e.g through [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter#quickstart))

## Installation

- install with your favourite package manager, e.g [packer](https://github.com/wbthomason/packer.nvim)
- call `setup` with your layout name and your layout configuration

e.g:

```lua
use {
    'codethread/qmk.nvim',
    config = function()
        ---@type qmk.UserConfig
        local conf = {
            name = 'LAYOUT_preonic_grid',
            layout = {
                '_ x x x x x x _ x x x x x x',
                '_ x x x x x x _ x x x x x x',
                '_ x x x x x x _ x x x x x x',
                '_ x x x x x x _ x x x x x x',
                '_ x x x x x x _ x x x x x x',
            }
        }
        require('qmk').setup(conf)
    end
}
```

## Configuration

qmk.nvim takes the following configuration (`---@type qmk.UserConfig`):

| setting                            | type                            | descritpion                                                                                                                                                                                                             |
| ---------------------------------- | ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                             | `string` **required**           | the name of your layout, for example `LAYOUT_preonic_grid` for the [preonic keyboard](https://github.com/qmk/qmk_firmware/blob/c5b0e3a6a3c5a86273b933c04f5cfdef9a541c9d/keyboards/preonic/keymaps/default/keymap.c#L53) |
| `layout`                           | `string[]` **required**         | the keyboard key layout, see [Layout](#Layout) for more details                                                                                                                                                         |
| `timeout`                          | `number`                        | (default `5000`) duration of vim.notify timeout if using [nvim-notify](https://github.com/rcarriga/nvim-notify)                                                                                                         |
| `auto_format_pattern`              | `string`                        | (default `*keymap.c`) the autocommand file pattern to use when applying [`QMKFormat`](#Commands) on save                                                                                                                |
| `comment_preview`                  | `table`                         | table of properties for rendering a pretty comment string of each keymap                                                                                                                                                |
| `comment_preview.position`         | `top`,`bottom`,`inside`, `none` | (default `top`) control the position of the preview, set to `none` to disable                                                                                                                                           |
| `comment_preview.keymap_overrides` | `table<string, string>`         | a dictionary of key codes to text replacements, any provided value will be merged with the existing dictionary, see [key_map.lua](./lua/qmk/config/key_map.lua) for details                                             |
| `comment_preview.symbols`          | `table<string, string>`         | a dictionary of symbols used for the preview comment border chars see [default.lua](./lua/qmk/config/default.lua) for details                                                                                           |

### examples

here are some example configurations:

<details>
  <summary>Disabling most features</summary>

```lua
{
    name = 'Some_layout',
    layout = { { 'x', 'x' } },
    auto_format_pattern = nil,
    comment_preview = {
        position = 'none'
    }
}
```

</details>

<details>
<summary>Overriding a long key code</summary>

for the configuration

```lua
{
	name = 'Some_layout',
	layout = { 'x x' },
	comment_preview = {
		position = 'inside',
		keymap_overrides = {
            -- key codes are mapped literally against the entire key in your layout
            -- longer key codes are checked first, and these will replace the value displayed in the preview
            --
            -- lua magic patterns must be escaped with `%`, sorry, I'll fix this one day
            -- watch ot for emojis as they are double width
			['LSG%(KC_GRAVE%)'] = 'Next Window',
		},
	},
}
```

with keymap.c:

```c
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
[_QWERTY] = Some_layout(
  KC_1
  ,
  LSG(KC_GRAVE)
)
}
```

becomes:

```c
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
[_QWERTY] = Some_layout(
//    ┌───┬─────────────┐
//    │ 1 │ Next Window │
//    └───┴─────────────┘
  KC_1 , LSG(KC_GRAVE)
)
}
```

Also if your key codes are quite long, you can define aliases in `c`

```c
//Aliases for longer keycodes
#define NUMPAD  TG(_NUMPAD)
```

</details>

<details>
<summary>A pretty kinisis layout</summary>

for the configuration

```lua
{
    name = 'LAYOUT_pretty',
    layout = {
        'x x x x x x x x x x x x x x x x x x',
        'x x x x x x _ _ _ _ _ _ x x x x x x',
        'x x x x x x _ _ _ _ _ _ x x x x x x',
        'x x x x x x _ _ _ _ _ _ x x x x x x',
        'x x x x x x _ _ _ _ _ _ x x x x x x',
        '_ x x x x _ _ _ _ _ _ _ _ x x x x _',
        '_ _ _ _ _ x x _ _ _ _ x x _ _ _ _ _',
        '_ _ _ _ _ _ x _ _ _ _ x _ _ _ _ _ _',
        '_ _ _ _ x x x _ _ _ _ x x x _ _ _ _',
    },
}
```

will format to something like:

```c
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
//    ┌──────┬────┬─────┬──────┬──────┬──────┬──────┬────┬────┬────┬─────┬──────┬──────┬──────┬──────┬──────┬────┬─────────┐
//    │ esc  │ f1 │ f2  │  f3  │  f4  │  f5  │  f6  │ f7 │ f8 │ f9 │ f10 │ f11  │ f12  │ pscr │ slck │ paus │ no │ QK_BOOT │
//    ├──────┼────┼─────┼──────┼──────┼──────┼──────┴────┴────┴────┴─────┴──────┼──────┼──────┼──────┼──────┼────┼─────────┤
//    │  =   │ 1  │  2  │  3   │  4   │  5   │                                  │  6   │  7   │  8   │  9   │ 0  │    -    │
//    ├──────┼────┼─────┼──────┼──────┼──────┤                                  ├──────┼──────┼──────┼──────┼────┼─────────┤
//    │ tab  │ q  │  w  │  e   │  r   │  t   │                                  │  y   │  u   │  i   │  o   │ p  │   '\'   │
//    ├──────┼────┼─────┼──────┼──────┼──────┤                                  ├──────┼──────┼──────┼──────┼────┼─────────┤
//    │ caps │ a  │  s  │  d   │  f   │  g   │                                  │  h   │  j   │  k   │  l   │ ;  │   "'"   │
//    ├──────┼────┼─────┼──────┼──────┼──────┤                                  ├──────┼──────┼──────┼──────┼────┼─────────┤
//    │ lsft │ z  │  x  │  c   │  v   │  b   │                                  │  n   │  m   │  ,   │  .   │ /  │  rsft   │
//    └──────┼────┼─────┼──────┼──────┼──────┘                                  └──────┼──────┼──────┼──────┼────┼─────────┘
//           │ `  │ ins │ left │ rght │                                                │  up  │ down │  [   │ ]  │
//           └────┴─────┴──────┴──────┼──────┬──────┐                    ┌──────┬──────┼──────┴──────┴──────┴────┘
//                                    │ lctl │ lalt │                    │ rgui │ rctl │
//                                    └──────┼──────┤                    ├──────┼──────┘
//                                           │ home │                    │ pgup │
//                             ┌──────┬──────┼──────┤                    ├──────┼──────┬──────┐
//                             │ bspc │ del  │ end  │                    │ pgdn │ ent  │ spc  │
//                             └──────┴──────┴──────┘                    └──────┴──────┴──────┘
[QWERTY] = LAYOUT_pretty(
  KC_ESC  , KC_F1  , KC_F2  , KC_F3   , KC_F4   , KC_F5   , KC_F6   , KC_F7 , KC_F8 , KC_F9 , KC_F10 , KC_F11  , KC_F12   , KC_PSCR , KC_SLCK , KC_PAUS , KC_NO   , QK_BOOT,
  KC_EQL  , KC_1   , KC_2   , KC_3    , KC_4    , KC_5    ,                                                      KC_6     , KC_7    , KC_8    , KC_9    , KC_0    , KC_MINS,
  KC_TAB  , KC_Q   , KC_W   , KC_E    , KC_R    , KC_T    ,                                                      KC_Y     , KC_U    , KC_I    , KC_O    , KC_P    , KC_BSLS,
  KC_CAPS , KC_A   , KC_S   , KC_D    , KC_F    , KC_G    ,                                                      KC_H     , KC_J    , KC_K    , KC_L    , KC_SCLN , KC_QUOT,
  KC_LSFT , KC_Z   , KC_X   , KC_C    , KC_V    , KC_B    ,                                                      KC_N     , KC_M    , KC_COMM , KC_DOT  , KC_SLSH , KC_RSFT,
            KC_GRV , KC_INS , KC_LEFT , KC_RGHT ,                                                                           KC_UP   , KC_DOWN , KC_LBRC , KC_RBRC          ,
                                                  KC_LCTL , KC_LALT ,                                  KC_RGUI , KC_RCTL                                                   ,
                                                            KC_HOME ,                                  KC_PGUP                                                             ,
                                        KC_BSPC , KC_DEL  , KC_END  ,                                  KC_PGDN , KC_ENTER , KC_SPC
)
};
```

</details>

## Layout

The `layout` config describes your layout as expected by qmk_firmware. As qmk_firmware is simply expecting an array of key codes, the layout is pretty much up to you.

A `layout` is a list of strings, where each string in the list represents a single row. Rows must all be the same width, and you'll see they visuall align to what your keymap looks like.

Valid keys are

- `x`: indicates presence of key
- ` `: space used to separete keys (must be used, and only use single spaces)
- `_`: indicates an empty space (e.g to split left and right, or adding padding)
- `x^x`: a key spanning multiple slots on the keyboard, the `^` indicates alignment. (NOTE vertically sized keys, like some thumb clusters are net yet supported)
  - `^xx`: left align across two columns
  - `x^x`: center align
  - `xx^`: right align
  - `xx^xx`: center align but across three columns

### examples

_there is [also a test file](./test/spec/qmk/format/keymap_spec.lua) with a great many examples_

<details>
  <summary>two rows, two columns</summary>

config:

```lua
{ layout = {
    'x x',
    'x x'
} }
```

output:

```c
[1] = Layout(
  KC_A , KC_B,
  KC_C , KC_D
)
```

</details>

<details>
  <summary>one column, four rows</summary>

config:

```lua
{ layout = {
    'x',
    'x',
    'x',
    'x'
} }
```

output:

```c
[1] = Layout(
  KC_A ,
  KC_B ,
  KC_C ,
  KC_D
)
```

</details>

<details>
  <summary>two rows, two columns, but with a centered key</summary>

config:

```lua
{ layout = {
    'x x',
    'x^x',
} }
```

output:

```c
[1] = Layout(
   KC_A , KC_B,
      KC_C
)
```

</details>

<details>
  <summary>two rows, three columns, and with a centered key</summary>

config:

```lua
{ layout = {
    'x _ x', -- we need the '_' to pad out the gaps
    'xx^xx', -- this spans 3 columns, but we could keep going to 5,7,9 etc
} }
```

output:

```c
[1] = Layout(
   KC_A ,     KC_B,
        KC_C
)
```

</details>

## Usage

### Commands

- `QMKFormat`: format the current buffer

### lua

- `:lua require('qmk').setup( <config> )`: setup qmk using your [config](#Configuration) (must be called before format, can be called repeatedly)
- `:lua require('qmk').format( <buf id ?> )`: format a given buffer, or the current if <buf id> is not provided

### Autocommands

The default settings will create an autocommand that formats your buffer on save. The name of the file can be changed with `auto_format_pattern`

## Debugging

Getting your layout right may be a slightly iterative process, so I recomend the following:

- open a scratch buffer next to your `keymap.c` file
- get the buffer id of your `keymap.c` file with `:lua print(vim.api.nvim_get_current_buf())`
- in your scratch buffer, call `qmk.setup { .. your config }` and `qmk.format(<buf id>)`
- from within your scratch buffer evaluate with `luafile %`

e.g:

```lua
-- scratch buffer (:enew)
local qmk = require('qmk')
qmk.setup({
	name = 'Some_layout',
	layout = { 'x x' },
	comment_preview = {
		position = 'inside'
	},
})

qmk.format(43) -- the result of calling :lua print(vim.api.nvim_get_current_buf()) in my keymap.c file
```

### Errors:

I have tried to create useful errors when something is wrong with the config, layout or your current keymap, but please raise an issue if something isn't clear (or you get an `QMK: E00`, as that's defiantely on me).

## Thanks

- [go-qmk-keymap](https://github.com/jurgen-kluft/go-qmk-keymap): this looks cool but still alpha.
- [2hwk/Q2K](https://github.com/2hwk/Q2K): same idea, in python, didn't work for me for some reason, but I stole the [keycode map](https://github.com/2hwk/Q2K/blob/master/q2k/reference.py), thanks!
- [this excellent nvim intro](https://www.youtube.com/watch?v=9gUatBHuXE0&t=0s) by TJ DeVries on how to use a powerful set of neovim's builtin features (which inspired and taught me how to make this).
- [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua): I stole your approach for validating user config, nice idea!
