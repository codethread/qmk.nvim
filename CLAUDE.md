# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

**Testing:**
- `make test` - Run all tests using plenary.nvim
- `make test SPEC=path/to/file_spec.lua` - Run specific test file
- `make watch` - Watch for changes and auto-run tests
- `make nvim` - Open Neovim with test environment loaded

**Code Quality:**
- `make lint` - Run luacheck on lua/ directory
- `make format` - Format code with stylua
- `make types` - Run type checking

**Setup:**
- `make prepare` - Install luacheck and clone test dependencies
- `make all` - Run prepare, lint, test, and types

## Architecture Overview

### Core Structure
This is a Neovim plugin that formats QMK and ZMK keyboard keymaps. The codebase is organized into distinct modules:

**Main Entry:** `/lua/qmk/plugin.lua` - Plugin initialization and user commands (also accessible via `require('qmk')`)
**Config System:** `/lua/qmk/config/` - Parse and validate user configuration, handle layout plans
**Hardware-specific modules:** `/lua/qmk/qmk/` and `/lua/qmk/zmk/` - Each contains parse.lua, format.lua, and queries.lua for their respective hardware
**Shared Formatting:** `/lua/qmk/formatting/` - Common formatting utilities (preview, key_text, key_rows)
**Shared Parsing:** `/lua/qmk/parsing/` - Common parsing utilities (inline_config, visitor)
**Data Structures:** `/lua/qmk/data/` - Core types like LayoutGrid for 2D layout management

### Key Data Flow
1. **Configuration**: User layout strings → validated `qmk.LayoutPlan` → merged with hardware-specific defaults
2. **Parsing**: File content → treesitter → hardware-specific queries → `qmk.Keymaps` structure
3. **Formatting**: `qmk.Keymaps` + config → `LayoutGrid` → hardware-specific formatter → aligned output

### Hardware Support
- **QMK**: C files using C treesitter parser, outputs C array format
- **ZMK**: `.keymap` files using devicetree parser, outputs devicetree format with ASCII previews

### Key Components
- `LayoutGrid` class: Manages 2D key layout with spanning, padding, and alignment calculations
- Hardware-specific parsers in `qmk/parse.lua` and `zmk/parse.lua` with custom treesitter queries in their respective `queries.lua`
- Hardware-specific formatters in `qmk/format.lua` and `zmk/format.lua` for C syntax vs devicetree syntax
- Inline JSON config support parsed from keymap file comments via `parsing/inline_config.lua`

### Testing Structure
- Tests use plenary.nvim framework
- Extensive fixture files in `test/fixtures/` for both QMK and ZMK
- Spec files alongside implementation files (e.g., `formatting/init_spec.lua` next to `formatting/init.lua`)
- Test utilities in `_test_utils.lua` for common test patterns

### Configuration Philosophy
- User provides layout as visual strings (e.g., `'x x x'`, `'x^x'` for spanning keys)
- Plugin parses layout into structured plans with validation via `config/parse.lua`
- Supports inline JSON config in keymap file comments for per-file overrides
- Hardware-specific keycode mappings in `config/qmk_keycodes.lua` and `config/zmk_keycodes.lua`