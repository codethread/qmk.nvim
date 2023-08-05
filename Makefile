SPEC=

RUN=nvim --headless --noplugin -u test/spec.vim

.PHONY: all nvim test watch prepare

prepare:
	luarocks install luacheck --local
	git clone --depth 1 https://github.com/nvim-lua/plenary.nvim ./test/vendor/plenary.nvim
	git clone --depth 1 https://github.com/m00qek/matcher_combinators.lua ./test/vendor/matcher_combinators

nvim:
	@nvim --noplugin -u test/spec.vim

test:
ifeq ($(strip $(SPEC)),) # a.k.a. $(SPEC) is empty
	@$(RUN) -c "PlenaryBustedDirectory lua/ { minimal_init = 'test/spec.vim' }"
else
	@$(RUN) -c "PlenaryBustedFile $(SPEC)"
endif

watch:
	@echo -e '\nRunning tests on "lua/qmk/**/*_spec.lua" when any Lua file on "lua" and "test/spec" changes\n'
	@find ./test/spec/ ./lua/ -name '*.lua' \
	  | entr make test SPEC=$(SPEC)

lint:
	@luacheck lua/

format:
	@stylua --glob '**/*.lua' lua

all: prepare test
