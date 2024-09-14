// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
[_QWERTY] = MY_LAYOUT(
      KC_1 , KC_2 , KC_3 , BAR , KC_5
),

[_SOMETHING] = MY_LAYOUT(
      KC_1 , KC_2 , FOO , KC_4 , KC_5
)
};

/*
qmk:json:start
{
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
