if vim.version().minor < 10 then
	vim.api.nvim_err_writeln('qmk requires at least nvim v0.10')
	return
end

-- make sure this file is loaded only once
if vim.g.loaded_qmk == 1 then
	return
end
vim.g.loaded_qmk = 1
