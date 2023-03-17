set rtp^=./test/vendor/plenary.nvim/
set rtp^=./test/vendor/matcher_combinators.lua/
set rtp^=./

runtime plugin/plenary.vim

lua require('plenary.busted')
lua require('matcher_combinators.luassert')

runtime plugin/qmk.lua
