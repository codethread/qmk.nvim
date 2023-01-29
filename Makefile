SPEC=

RUN=nvim --headless --noplugin -u test/spec.vim

.PHONY: all nvim test watch prepare

prepare:
	git submodule update --depth 1 --init
	luarocks install luacheck --local

nvim:
	@nvim --noplugin -u test/spec.vim

test:
ifeq ($(strip $(SPEC)),) # a.k.a. $(SPEC) is empty
	@$(RUN) -c "PlenaryBustedDirectory test/spec/ { minimal_init = 'test/spec.vim' }"
else
	@$(RUN) -c "PlenaryBustedFile $(SPEC)"
endif

watch:
	@echo -e '\nRunning tests on "test/spec/**/*_spec.lua" when any Lua file on "lua" and "test/spec" changes\n'
	@find ./test/spec/ ./lua/ -name '*.lua' \
	  | entr make test SPEC=$(SPEC)

all: prepare test
