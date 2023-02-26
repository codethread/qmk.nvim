---@alias qmk.KeymapList {key: string, value: string}[]

---@class qmk.KeyMapModule
---@field key_map qmk.KeymapList
local M = {}

local key_map = {
	KC_TRANS = ' ',
	KC_A = 'A',
	KC_B = 'B',
	KC_C = 'C',
	KC_D = 'D',
	KC_E = 'E',
	KC_F = 'F',
	KC_G = 'G',
	KC_H = 'H',
	KC_I = 'I',
	KC_J = 'J',
	KC_K = 'K',
	KC_L = 'L',
	KC_M = 'M',
	KC_N = 'N',
	KC_O = 'O',
	KC_P = 'P',
	KC_Q = 'Q',
	KC_R = 'R',
	KC_S = 'S',
	KC_T = 'T',
	KC_U = 'U',
	KC_V = 'V',
	KC_W = 'W',
	KC_X = 'X',
	KC_Y = 'Y',
	KC_Z = 'Z',
	KC_COMMA = ',',
	KC_DOT = '.',
	KC_SCOLON = ';',
	KC_SCLN = ':',
	KC_SLASH = '/',
	KC_ESC = '⎋',
	KC_CUT = '✄',
	KC_UNDO = '↶',
	KC_REDO = '↷',
	KC_VOLU = '🕪',
	KC_VOLD = '🕩',
	KC_MUTE = '  🕨',
	KC_TAB = '⭾',
	KC_MENU = '𝌆',
	KC_CAPSLOCK = '⇪',
	KC_NUMLK = '⇭',
	KC_SCRLK = '⇳',
	KC_PRSCR = '⎙',
	KC_PAUSE = '⎉',
	KC_BREAK = '⎊',
	KC_ENTER = '⏎',
	KC_BSPACE = '⌫',
	KC_DELETE = '⌦',
	KC_INSERT = '⎀',
	KC_LEFT = '◁',
	KC_RIGHT = '▷',
	KC_UP = '△',
	KC_DOWN = '▽',
	KC_HOME = '⇤',
	KC_END = '⇥',
	KC_PGUP = '⇞',
	KC_PGDOWN = '⇟',
	KC_LSFT = '⇧',
	KC_RSFT = '⇧',
	KC_LCTL = '^',
	KC_RCTL = '^',
	KC_LALT = '⎇',
	KC_RALT = '⎇',
	KC_HYPER = '✧',
	KC_LGUI = '⌘',
	KC_RGUI = '⌘',
}

M.key_map = {}
for key, value in pairs(key_map) do
	table.insert(M.key_map, { key = key, value = value })
end
table.sort(M.key_map, function(a, b) return #a.key > #b.key end)

return M
