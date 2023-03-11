local print = {}
local symbols = {}

-- quick hack
function print.set_symbols(new_symbols) symbols = new_symbols end

function print.tl(width) return symbols.tl .. string.rep(symbols.horz, width) end
function print.tm(width) return symbols.tm .. string.rep(symbols.horz, width) end
function print.tr(width) return symbols.tm .. string.rep(symbols.horz, width) .. symbols.tr end
function print.tbridge(width) return symbols.horz .. string.rep(symbols.horz, width) end

function print.bl(width) return symbols.bl .. string.rep(symbols.horz, width) end
function print.bm(width) return symbols.bm .. string.rep(symbols.horz, width) end
function print.br(width) return symbols.bm .. string.rep(symbols.horz, width) .. symbols.br end
function print.bbridge(width) return symbols.horz .. string.rep(symbols.horz, width) end

function print.ml(width) return symbols.ml .. string.rep(symbols.horz, width) end
function print.mm(width) return symbols.mm .. string.rep(symbols.horz, width) end
function print.mr(width) return symbols.mm .. string.rep(symbols.horz, width) .. symbols.mr end
function print.mbridge(width) return symbols.horz .. string.rep(symbols.horz, width) end

function print.kl(key) return symbols.vert .. key end
function print.km(key) return symbols.vert .. key end
function print.kr(key) return symbols.vert .. key .. symbols.vert end
function print.kbridge(key) return symbols.vert .. key end

return print
