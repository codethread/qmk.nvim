local parse = require('qmk.config.parse')

-- currently only parses qmk style configs, deal with multiple options
-- when needed
return {
	parse = parse.parse,
}
