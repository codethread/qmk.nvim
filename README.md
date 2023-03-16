# qmk.nvim

automatically format your kemap.c qmk files

WIP, works just need to add docs

for example my config:

```lua
local qmk = require('qmk')
qmk.setup {
    name = 'LAYOUT_preonic_grid',
    layout = {
        '_ x x x x x x _ _ x x x x x x',
        '_ x x x x x x _ _ x x x x x x',
        '_ x x x x x x _ _ x x x x x x',
        '_ x x x x x x _ _ x x x x x x',
        '_ x x x x x x _ _ x x x x x x',
    }
}
```

valid keys are 
- `x`: indicates presence of key
- ` `: space used to separete keys (msut be used, and only use single spaces)
- `_`: indicates an empty space (e.g to split left and right, or adding padding)
- `x^x`: a key spanning multiple slots on the keyboard, the `^` indicates alignment
  - `^xx`: left align across two rows
  - `x^x`: center align
  - `xx^`: right align
  - `xx^xx`: center align but across three rows



if keys are too long
```c
//Aliases for longer keycodes
#define NUMPAD  TG(_NUMPAD)
```

