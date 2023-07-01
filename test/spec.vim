set rtp^=./test/vendor/plenary.nvim/
set rtp^=./test/vendor/matcher_combinators/
" adjust per machine
set rtp^=~/.local/share/nvim/lazy/nvim-treesitter
" CI
set rtp^=~/.local/share/nvim/site/pack/vendor/start/nvim-treesitter
set rtp^=./

runtime plugin/plenary.vim

lua require('plenary.busted')
lua require('matcher_combinators.luassert')

runtime plugin/qmk.lua
