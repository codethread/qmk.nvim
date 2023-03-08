local print = {}
local symbols = {}

-- quick hack
function print.set_symbols(new_symbols) symbols = new_symbols end

function print.tl(width) return symbols.tl .. string.rep(symbols.div, width) end
function print.tm(width) return symbols.tm .. string.rep(symbols.div, width) end
function print.tr(width) return symbols.tm .. string.rep(symbols.div, width) .. symbols.tr end
function print.tbridge(width) return symbols.div .. string.rep(symbols.div, width) end

function print.bl(width) return symbols.bl .. string.rep(symbols.div, width) end
function print.bm(width) return symbols.bm .. string.rep(symbols.div, width) end
function print.br(width) return symbols.bm .. string.rep(symbols.div, width) .. symbols.br end
function print.bbridge(width) return symbols.div .. string.rep(symbols.div, width) end

function print.ml(width) return symbols.ml .. string.rep(symbols.div, width) end
function print.mm(width) return symbols.mm .. string.rep(symbols.div, width) end
function print.mr(width) return symbols.mm .. string.rep(symbols.div, width) .. symbols.mr end
function print.mbridge(width) return symbols.div .. string.rep(symbols.div, width) end

function print.kl(key) return symbols.sep .. key end
function print.km(key) return symbols.sep .. key end
function print.kr(key) return symbols.sep .. key .. symbols.sep end
function print.kbridge(key) return symbols.sep .. key end

return print
