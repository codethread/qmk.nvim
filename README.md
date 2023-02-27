# qmk.nvim

automatically format your kemap.c qmk files

WIP, works but just need to add comment previews and improve error handling for incorrect config

for example my config:

```lua
local qmk = require('qmk')
qmk.setup {
│   name = 'LAYOUT_preonic_grid',
│   spacing = 8,
│   layout = {
│   ┊   '| x x x x x x | | x x x x x x',
│   ┊   '| x x x x x x | | x x x x x x',
│   ┊   '| x x x x x x | | x x x x x x',
│   ┊   '| x x x x x x | | x x x x x x',
│   ┊   '| x x x x x x | | x x x x x x',
│   }
}
```

valid keys are 
- `x`: indicates presence of key
- ` `: space used to separete keys (msut be used, and only use single spaces)
- `|`: indicates an empty space (must go all the way down the board, e.g to split left and right, or adding padding)
- `x^x`: a key spanning multiple slots on the keyboard, the `^` indicates alignment
  - `^xx`: left align across two rows
  - `x^x`: center align
  - `xx^`: right align
  - `xx^xx`: center align but across three rows



```c
//Aliases for longer keycodes
#define NUMPAD  TG(_NUMPAD)
```

