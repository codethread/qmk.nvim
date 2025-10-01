local empty = '   '

local M = {}

-- @type table<string, string>
M.zmk_key_map = {}

local zmk_key_map = {
	-- Behaviors
	[''] = { '&kp ', '&mkp ' },
	['mt'] = { '&mt' },
	['mo'] = { '&mo' },
	['lt'] = { '&lt' },
	['to'] = { '&to' },
	['tog'] = { '&tog', 'OUT_TOG', 'RGB_TOG', 'BL_TOG', 'EP_TOG' },
	['sl'] = { '&sl' },
	['kt'] = { '&kt' },
	['gresc'] = { '&gresc' },
	['capsw'] = { '&caps_word' },
	['keyr'] = { '&key_repeat' },
	[empty] = { '&trans', '&none' },
	['reset'] = { '&reset' },
	['boot'] = { '&bootloader' },

	-- Mouse emulation
	['lclk'] = { 'MB1', 'LCLK' },
	['rclk'] = { 'MB2', 'RCLK' },
	['mclk'] = { 'MB3', 'MCLK' },
	['mbck'] = { 'MB4' },
	['mfwd'] = { 'MB5' },

	-- RGB underglow
	['ug_'] = { '&rgb_ug' },
	['on'] = { 'RGB_ON', 'BL_ON', 'EP_ON', 'EP_OFF' },
	['off'] = { 'RGB_OFF', 'BL_OFF' },
	['hu+'] = { 'RGB_HUI' },
	['hu-'] = { 'RGB_HUD' },
	['sa+'] = { 'RGB_SAI' },
	['sa-'] = { 'RGB_SAD' },
	['br+'] = { 'RGB_BRI', 'BL_INC' },
	['br-'] = { 'RGB_BRD', 'BL_DEC' },
	['sp+'] = { 'RGB_SPI' },
	['sp-'] = { 'RGB_SPD' },
	['eff'] = { 'RGB_EFF' },
	['efr'] = { 'RGB_EFR' },
	['hsb'] = { 'RGB_COLOR_HSB' },

	-- RGB backlight
	['bl_'] = { '&bl' },
	['cycl'] = { 'BL_CYCLE' },
	['bri'] = { 'BL_SET' },

	-- Power management
	['epwr_'] = { '&ext_power' },

	-- Bluetooth
	['bt_'] = { '&bt ' },
	['clr'] = { 'BT_CLR' },
	['nxt'] = { 'BT_NXT' },
	['prv'] = { 'BT_PRV' },
	['sel'] = { 'BT_SEL' },

	-- Output selection
	['out_'] = { '&out' },
	['usb'] = { 'OUT_USB' },
	['ble'] = { 'OUT_BLE' },

	-- Symbols and punctuation
	['!'] = { 'EXCL', 'EXCLAMATION' },
	['@'] = { 'AT', 'AT_SIGN' },
	['#'] = { 'HASH', 'POUND' },
	['$'] = { 'DOLLAR', 'DLLR' },
	['%%'] = { 'PRCNT', 'PERCENT' },
	['^'] = { 'CARET' },
	['&'] = { 'AMPS', 'AMPERSAND' },
	['*'] = { 'ASTRK', 'ASTERISK', 'STAR' },
	['('] = { 'LPAR', 'LEFT_PARENTHESIS' },
	[')'] = { 'RPAR', 'RIGHT_PARENTHESIS' },
	['='] = { 'EQUAL' },
	['+'] = { 'PLUS' },
	['-'] = { 'MINUS' },
	['_'] = { 'UNDER', 'UNDERSCORE' },
	['/'] = { 'SLASH', 'FSLH' },
	['?'] = { 'QMARK', 'QUESTION' },
	['\\'] = { 'BSLH', 'BACKSLASH' },
	['iso\\'] = { 'NON_US_BACKSLASH', 'NON_US_BSLH', 'NUBS' },
	['|'] = { 'PIPE', 'PIPE2' },
	[';'] = { 'SEMI', 'SEMICOLON' },
	[':'] = { 'COLON' },
	["'"] = { 'SQT', 'SINGLE_QUOTE', 'APOSTROPHE', 'APOS' },
	['"'] = { 'DQT', 'DOUBLE_QUOTES' },
	[','] = { 'COMMA' },
	['<'] = { 'LT', 'LESS_THAN' },
	['.'] = { 'DOT', 'PERIOD' },
	['>'] = { 'GT', 'GREATER_THAN' },
	['['] = { 'LBKT', 'LEFT_BRACKET' },
	['{'] = { 'LBRC', 'LEFT_BRACE' },
	[']'] = { 'RBKT', 'RIGHT_BRACKET' },
	['}'] = { 'RBRC', 'RIGHT_BRACE' },
	['`'] = { 'GRAVE' },
	['~'] = { 'TILDE', 'TILDE2' },
	['iso#'] = { 'NUHS', 'NON_US_HASH' },

	-- Control and whitespace
	['esc'] = { 'ESC', 'ESCAPE' },
	['ent'] = { 'RET', 'ENTER', 'RETURN', 'RETURN2', 'RET2', 'KP_ENTER' },
	['spc'] = { 'SPC', 'SPACE' },
	['tab'] = { 'TAB' },
	['bspc'] = { 'BSPC', 'BACKSPACE' },
	['del'] = { 'DEL', 'DELETE' },
	['ins'] = { 'INS', 'INSERT' },

	-- Navigation
	['home'] = { 'HOME' },
	['end'] = { 'END' },
	['pgup'] = { 'PG_UP', 'PAGE_UP' },
	['pgdn'] = { 'PG_DN', 'PAGE_DOWN' },
	['up'] = { 'UP', 'UP_ARROW' },
	['down'] = { 'DOWN', 'DOWN_ARROW' },
	['left'] = { 'LEFT', 'LEFT_ARROW' },
	['rght'] = { 'RIGHT', 'RIGHT_ARROW' },
	['app'] = { 'K_APP', 'K_APPLICATION', 'K_CONTEXT_MENU', 'K_CMENU' },

	-- Modifiers
	['lsft'] = { 'LEFT_SHIFT', 'LSHIFT', 'LSHFT', 'LS' },
	['rsft'] = { 'RIGHT_SHIFT', 'RSHIFT', 'RSHFT', 'RS' },
	['lctl'] = { 'LEFT_CTRL', 'LCTRL', 'LC' },
	['rctl'] = { 'RIGHT_CTRL', 'RCTRL', 'RC' },
	['lalt'] = { 'LEFT_ALT', 'LALT', 'LA' },
	['ralt'] = { 'RIGHT_ALT', 'RALT', 'RA' },
	['lgui'] = {
		'LEFT_GUI',
		'LGUI',
		'LG',
		'LEFT_WIN',
		'LWIN',
		'LEFT_COMMAND',
		'LCMD',
		'LEFT_META',
		'LMETA',
	},
	['rgui'] = {
		'RIGHT_GUI',
		'RGUI',
		'RG',
		'RIGHT_WIN',
		'RWIN',
		'RIGHT_COMMAND',
		'RCMD',
		'RIGHT_META',
		'RMETA',
	},

	-- Locks
	['caps'] = { 'CAPSLOCK', 'CAPS', 'CLCK' },
	['lcaps'] = { 'LOCKING_CAPS', 'LCAPS' },
	['slck'] = { 'SCROLLLOCK', 'SLCK' },
	['lslck'] = { 'LOCKING_SCROLL', 'LSLCK' },
	['lnlck'] = { 'LOCKING_NUM', 'LNLCK' },

	-- International
	['int_ro'] = { 'INTERNATIONAL_1', 'INT1', 'INT_RO' },
	['int_kan'] = { 'INTERNATIONAL_2', 'INT2', 'INT_KANA', 'INT_KATAKANAHIRAGANA' },
	['int_yen'] = { 'INTERNATIONAL_3', 'INT3', 'INT_YEN' },
	['int_hen'] = { 'INTERNATIONAL_4', 'INT4', 'INT_HENKAN' },
	['int_muh'] = { 'INTERNATIONAL_5', 'INT5', 'INT_HENKAN' },
	['int_kpj'] = { 'INTERNATIONAL_6', 'INT6', 'INT_KPJPCOMMA' },
	['int_7'] = { 'INTERNATIONAL_7', 'INT6' },
	['int_8'] = { 'INTERNATIONAL_8', 'INT6' },
	['int_9'] = { 'INTERNATIONAL_9', 'INT6' },

	-- Language
	['lang_hang'] = { 'LANGUAGE_1', 'LANG1', 'LANG_HANGUL' },
	['lang_hanj'] = { 'LANGUAGE_2', 'LANG2', 'LANG_HANJA' },
	['lang_kat'] = { 'LANGUAGE_3', 'LANG3', 'LANG_KATAKANA' },
	['lang_hir'] = { 'LANGUAGE_4', 'LANG4', 'LANG_HIRAGANA' },
	['lang_zen'] = { 'LANGUAGE_5', 'LANG5', 'LANG_ZENKAKUHANKAKU' },
	['lang_6'] = { 'LANGUAGE_6', 'LANG6' },
	['lang_7'] = { 'LANGUAGE_7', 'LANG7' },
	['lang_8'] = { 'LANGUAGE_8', 'LANG8' },
	['lang_9'] = { 'LANGUAGE_9', 'LANG9' },

	-- Miscellaneous
	['pscr'] = { 'PRINTSCREEN', 'PSCRN' },
	['paus'] = { 'PAUSE_BREAK' },
	['alt_erase'] = { 'ALT_ERASE' },
	['sys_req'] = { 'SYSREQ', 'ATTENTION' },
	['k_cancel'] = { 'K_CANCEL' },
	['clear'] = { 'CLEAR', 'KP_CLEAR', 'CLEAR2' },
	['clear_again'] = { 'CLEAR_AGAIN' },
	['crsel'] = { 'CRSEL' },
	['prior'] = { 'PRIOR' },
	['separator'] = { 'SEPARATOR' },
	['out'] = { 'OUT' },
	['oper'] = { 'OPER' },
	['exsel'] = { 'EXSEL' },
	['k_edit'] = { 'K_EDIT' },

	-- Keypad
	['nlck'] = { 'KP_NUMLOCK', 'KP_NUM', 'KP_NLCK' },

	-- Symbols and operations
	['kp_+'] = { 'KP_PLUS' },
	['kp_-'] = { 'KP_MINUS', 'KP_SUBTRACT' },
	['kp_*'] = { 'KP_MULTIPLY', 'KP_ASTERISK' },
	['kp_/'] = { 'KP_DIVIDE', 'KP_SLASH' },
	['kp_='] = { 'KP_EQUAL', 'KP_EQUAL_AS400' },
	['kp_.'] = { 'KP_DOT' },
	['kp_,'] = { 'KP_COMMA' },
	['kp_('] = { 'KP_LPAR', 'KP_LEFT_PARENTHESIS' },
	['kp_)'] = { 'KP_COMMA', 'KP_RIGHT_PARENTHESIS' },

	-- Cut, copy, paste
	['cut'] = { 'C_AC_CUT', 'K_CUT' },
	['copy'] = { 'C_AC_COPY', 'K_COPY' },
	['paste'] = { 'c_ac_paste', 'k_paste' },

	-- Undo, redo
	['undo'] = { 'C_AC_UNDO', 'K_UNDO' },
	['redo'] = { 'C_AC_REDO' },
	['again'] = { 'K_AGAIN', 'K_REDO' },

	-- Sound and volume
	['volu'] = {
		'C_VOLUME_UP',
		'C_VOL_UP',
		'K_VOLUME_UP',
		'K_VOL_UP',
		'K_VOLUME_UP2',
		'K_VOL_UP2',
	},
	['vold'] = {
		'C_VOLUME_DOWN',
		'C_VOL_DN',
		'K_VOLUME_DOWN',
		'K_VOL_DN',
		'K_VOLUME_DOWN2',
		'K_VOL_DN2',
	},
	['mute'] = { 'C_MUTE', 'K_MUTE', 'K_MUTE2' },
	['alt_audio_inc'] = { 'C_ALTERNATE_AUDIO_INCREMENT', 'C_ALT_AUDIO_INC' },
	['bass_boost'] = { 'C_BASS_BOOST' },

	-- Display
	['bri+'] = { 'C_BRIGHTNESS_INC', 'C_BRI_INC', 'C_BRI_UP' },
	['bri-'] = { 'C_BRIGHTNESS_DEC', 'C_BRI_DEC', 'C_BRI_DN' },
	['bri_min'] = { 'C_BRIGHTNESS_MINIMUM', 'C_BRI_MIN' },
	['bri_max'] = { 'C_BRIGHTNESS_MAXIMUM', 'C_BRI_MAX' },
	['bri_auto'] = { 'C_BRIGHTNESS_AUTO', 'C_BRI_AUTO' },
	['bl_tgl'] = { 'C_BACKLIGHT_TOGGLE', 'C_BKLT_TOG' },
	['aspect'] = { 'C_ASPECT' },
	['pip'] = { 'C_PIP' },

	-- Media controls
	['rec'] = { 'C_RECORD', 'C_REC' },
	['play'] = { 'C_PLAY', 'C_PLAY_PAUSE', 'C_PP', 'K_PLAY_PAUSE', 'K_PP' },
	['pause'] = { 'C_PAUSE' },
	['stop'] = { 'C_STOP', 'K_STOP2', 'K_STOP3' },
	['stop_eject'] = { 'C_STOP_EJECT' },
	['eject'] = { 'C_EJECT', 'K_EJECT' },
	['next'] = { 'C_NEXT', 'K_NEXT' },
	['prev'] = { 'C_PREVIOUS', 'C_PREV', 'K_PREVIOUS', 'K_PREV' },
	['ff'] = { 'C_FAST_FORWARD', 'C_FF' },
	['rw'] = { 'C_REWIND', 'C_RW' },
	['slow'] = { 'C_SLOW', 'C_SLOW_TRACKING', 'C_SLOW2' },
	['repeat'] = { 'C_REPEAT' },
	['rand'] = { 'C_RANDOM_PLAY', 'C_SHUFFLE' },
	['cc'] = { 'C_CAPTIONS', 'C_SUBTITLES' },
	['data_on_screen'] = { 'C_DATA_ON_SCREEN' },
	['snap'] = { 'C_SNAPSHOT' },

	-- Consumer menus
	-- TODO

	-- Consumer controls
	-- TODO

	-- Application controls
	-- TODO

	-- Application launch
	-- TODO

	-- Input assist
	['asst_next'] = { 'C_KEYBOARD_INPUT_ASSIST_NEXT', 'C_KBIA_NEXT' },
	['asst_prev'] = { 'C_KEYBOARD_INPUT_ASSIST_PREVIOUS', 'C_KBIA_PREV' },
	['asst_next_group'] = { 'C_KEYBOARD_INPUT_ASSIST_NEXT_GROUP', 'C_KBIA_NEXT_GRP' },
	['asst_prev_group'] = { 'C_KEYBOARD_INPUT_ASSIST_PREVIOUS_GROUP', 'C_KBIA_PREV_GRP' },
	['asst_accept'] = { 'C_KEYBOARD_INPUT_ASSIST_ACCEPT', 'C_KBIA_ACCEPT' },
	['asst_cancel'] = { 'C_KEYBOARD_INPUT_ASSIST_CANCEL', 'C_KBIA_CANCEL' },

	-- Power and lock
	['pwr'] = { 'C_POWER', 'C_PWR', 'K_POWER', 'K_PWR' },
	['pwr_reset'] = { 'C_RESET' },
	['sleep'] = { 'C_SLEEP', 'K_SLEEP' },
	['sleep_mode'] = { 'C_SLEEP_MODE' },
	['log_off'] = { 'C_AL_LOGOFF' },
	['term_lock'] = { 'C_AL_LOCK', 'C_AL_SCREENSAVER', 'C_AL_COFFEE' },
	['lock'] = { 'K_LOCK', 'K_SCREENSAVER', 'K_COFFEE' },
}

-- Swap mappings keys and values
for key, value in pairs(zmk_key_map) do
	for _, v in ipairs(value) do
		M.zmk_key_map[v] = key
	end
end

-- Create number mappings
for i = 0, 9 do
	M.zmk_key_map['N' .. i] = tostring(i)
	M.zmk_key_map['NUMBER_' .. i] = tostring(i)
	M.zmk_key_map['KP_NUMBER_' .. i] = tostring(i)
	M.zmk_key_map['KP_N' .. i] = tostring(i)
end

-- Create function mappings
for i = 1, 24 do
	M.zmk_key_map['F' .. i] = 'f' .. i
end

return M
