local parse = require('qmk.lib.parse')

-- currently only parses qmk style configs, deal with multiple options
-- when needed
return {
	parse = parse.parse,
}
