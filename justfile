prepare:
	luarocks install luacheck --local
	git clone --depth 1 https://github.com/nvim-lua/plenary.nvim ./test/vendor/plenary.nvim
	git clone --depth 1 https://github.com/m00qek/matcher_combinators.lua ./test/vendor/matcher_combinators

test *FILES:
  ./scripts/test {{FILES}}

watch *FILES:
  ./scripts/watch {{FILES}}

lint:
	luacheck lua/

format:
	stylua --glob '**/*.lua' lua
