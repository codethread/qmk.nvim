if vim.fn.has 'nvim-0.7.0' == 0 then
	vim.api.nvim_err_writeln 'qmk requires at least nvim-0.7.0.1'
	return
end

-- make sure this file is loaded only once
if vim.g.loaded_qmk == 1 then return end
vim.g.loaded_qmk = 1
