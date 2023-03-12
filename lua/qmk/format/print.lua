local print = {}

---@type qmk.PreviewSymbols
local symbols = {}
local space = ' '

-- quick hack
function print.set_symbols(new_symbols) symbols = new_symbols end

function print.space(width) return string.rep(space, width) end

function print.tl(width) return string.rep(space, width) .. symbols.tl end
function print.tm(width) return string.rep(symbols.horz, width) .. symbols.tm end
function print.tr(width) return string.rep(symbols.horz, width) .. symbols.tm .. symbols.tr end
function print.tbridge(width) return string.rep(symbols.horz, width) .. symbols.horz end

function print.bl(width) return symbols.bl .. string.rep(symbols.horz, width) end
function print.bm(width) return string.rep(symbols.horz, width) .. symbols.bm end
function print.br(width) return string.rep(symbols.horz, width) .. symbols.bm .. symbols.br end
function print.bbridge(width) return string.rep(symbols.horz, width) .. symbols.horz end

function print.ml(width) return string.rep(symbols.horz, width) .. symbols.ml end
function print.mm(width) return string.rep(symbols.horz, width) .. symbols.mm end
function print.mr(width) return string.rep(symbols.horz, width) .. symbols.mm .. symbols.mr end
function print.mbridge(width) return string.rep(symbols.horz, width) .. symbols.horz end

function print.kl(key) return symbols.vert .. key end
function print.km(key) return symbols.vert .. key end
function print.kr(key) return symbols.vert .. key .. symbols.vert end
function print.kbridge(key) return symbols.vert .. key end

return print
