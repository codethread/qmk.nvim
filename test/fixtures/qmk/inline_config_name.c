// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
//    ┌────────┬───┬───┐
//    │   1    │ 2 │ 3 │
//    ├────────┼───┼───┴───┐
//    │ BUTTER │   │   5   │
//    └────────┘   └───────┘
[_QWERTY] = MY_LAYOUT(
  KC_1 , 


		KC_2 , KC_3    ,
  BAR  
		,    
		KC_5
),

//    ┌───┬───┬────┐
//    │ 1 │ 2 │ 😎 │
//    ├───┼───┼────┴───┐
//    │ 4 │   │   5    │
//    └───┘   └────────┘
[_SOMETHING] = MY_LAYOUT(
  KC_1 , 
		KC_2 , 
		FOO ,
  KC_4 ,    KC_5
)
};

/*
qmk:json:start
{
  "name": "MY_LAYOUT",
  "layout": [
    "x x x _",
    "x _ ^xx"
  ],
  "comment_preview": {
    "keymap_overrides": {
      "BAR": "BUTTER",
      "FOO": "😎"
    }
  }
}
qmk:json:end
*/
