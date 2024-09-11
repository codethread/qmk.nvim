---cli arguments expected as key=value pairs
---@return Args
local function parseArgs()
	local args = _G.arg

	---@type Args
	local out = {}

	for _, arg in ipairs(args) do
		local key, value = arg:match('^%-%-([%w-]+)=(.+)$')
		if key then
			--- NOTE: CLI ARGS HERE
			if key == 'cmd' then
				out.cmd = value
			elseif key == 'skip-tests' then
				out.skip_tests = true
			elseif key == 'level' then
				out.level = value
			end
		end
	end

	return out
end

-- Color enum
local Color = {
	RED = '31',
	GREEN = '32',
	YELLOW = '33',
	BLUE = '34',
	MAGENTA = '35',
	CYAN = '36',
	WHITE = '37',
	GREY = '90',
}

local Level = { --what are these
	Error = 'Error',
	Warning = 'Warning',
	Information = 'Information',
	Hint = 'Hint',
}

--- Generates an ANSI escape sequence for setting text color and style.
-- @param color Color The color from the Color enum.
-- @param isBold boolean Whether the text should be bold.
-- @return string The ANSI escape sequence.
local function getColorStyleSequence(color, isBold)
	local boldCode = isBold and '1;' or ''
	return string.format('\27[%s%sm', boldCode, color)
end

--- Generates an ANSI escape sequence for resetting text color and style.
-- @return string The ANSI escape sequence for reset.
local function getResetSequence()
	return '\27[0m'
end

--- Formats text with color and optional bold styling.
-- @param text string The text to be formatted.
-- @param color Color The color from the Color enum.
-- @param isBold boolean Whether the text should be bold.
-- @return string The formatted text string.
local function c(text, color, isBold)
	local colorSequence = getColorStyleSequence(color, isBold)
	local resetSequence = getResetSequence()
	return string.format('%s%s%s', colorSequence, text, resetSequence)
end

local function read_file(path)
	local file = io.open(path, 'rb') -- r read mode and b binary mode
	if not file then
		return nil
	end
	local content = file:read('*a') -- *a or *all reads the whole file
	file:close()
	return content
end

---@param cliArgs Args
local function main(cliArgs)
	local cmd = {
		cliArgs.cmd or 'lua-language-server',
		'--check',
		'.',
		'--logpath=reports',
		'--checklevel=' .. (cliArgs.level or Level.Hint),
		'--configpath=.luarc.jsonc',
	}

	vim.system(cmd):wait()

	local raw = read_file('./reports/check.json')
	assert(raw, 'no file')

	---@type { [string]: Report[] }
	local json = vim.json.decode(raw)

	--- TODO: make better
	local diagnostics = {
		errors = 0,
	}

	local filters = {
		'Undefined field `combinators`.',
	}

	for file, errors in pairs(json) do
		local fname = file:gsub('file://' .. os.getenv('PWD'), ''):gsub('/./', '')

		if not cliArgs.skip_tests or not fname:match('.+_spec.lua$') then
			for _, e in ipairs(errors) do
				if not vim.list_contains(filters, e.message) then
					diagnostics.errors = diagnostics.errors + 1

					io.write(
						c(fname, Color.CYAN)
							.. ':'
							.. c(tonumber(e.range.start.line) + 1, Color.YELLOW)
							.. ':'
							.. c(tonumber(e.range.start.character) + 1, Color.YELLOW)
							.. ' - '
							.. c(e.severity, Color.RED)
							.. ' '
							.. c(e.code .. ':', Color.GREY)
							.. '\n'
							.. e.message
					)
					io.write('\n\n')
				end
			end
		end
	end

	print('Complete, ' .. diagnostics.errors .. ' problems found\n')
	if diagnostics.errors > 0 then
		os.exit(1)
	end
end

main(parseArgs())

---@class Pos
---@field character string
---@field line string

---@class Report
---@field code string
---@field severity number
---@field source string
---@field message string
---@field range { end: Pos, start: Pos }

---@class Args
---@field cmd? string optional path to lsp command
---@field level? string optional error level
---@field skip_tests? boolean optional skip spec files
