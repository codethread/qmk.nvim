local get_keymap = require 'qmk.parse.get_qmk_keymaps'

local M = {}

---currenly only supports qmk keymaps, but in theory could support anything that parses to a qmk.Keymap
M.parse = get_keymap

return M
