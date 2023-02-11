const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

    // clang-format off
[_QWERTY] = LAYOUT_preonic_grid(
     KC_ESC        , KC_1    , KC_2 
        , KC_3    , KC_4               , KC_5                  , KC_6      
        , KC_7               , KC_8          , KC_9    , KC_0    , KC_F12,
 KC_TAB        , KC_Q    , KC_W    , KC_E    , KC_R               , KC_T               , KC_Y                 , KC_U               , KC_I          , KC_O    , KC_P    , KC_ENT,
 CTL_T(KC_ESC) ,     
        KC_A    , KC_S    , KC_D    , KC_F            , KC_G                  , KC_H                 , KC_J                      , KC_K          , KC_L    , KC_SCLN , KC_QUOT,
 KC_LSFT       , KC_Z    ,         KC_X    , KC_C    , KC_V           , KC_B                  , KC_N                 , KC_M               , KC_COMM          , KC_DOT  , KC_SLSH , KC_RSFT,
 MO(_ADJUST)   , KC_LCTL , KC_LALT ,        KC_LGUI ,                LT(_LOWER, KC_ENT) ,
        LT(_SHIFTED, KC_TAB)   , LT(_ARROWS, KC_BSPC) , LT(_LOWER, KC_SPC)               , ALT_T(KC_ESC)          , KC_LALT ,           KC_LCTL , MO(_ARROWS)
),

[_SOMETHING] = LAYOUT_preonic_grid(
     KC_ESC        , KC_1    , KC_2 , KC_3    , KC_4               , KC_5                  , KC_6      
        , KC_7               , KC_8          , KC_9    , KC_0    , KC_F12,
 KC_TAB        , KC_Q    , KC_W    , KC_E    , KC_R               , KC_T               , KC_Y                 , KC_U               , KC_I          , KC_O    , KC_P    , KC_ENT,
 CTL_T(KC_ESC) ,     
        KC_A    , KC_S    , KC_D    , KC_F            , KC_G                  , KC_H                 , KC_J                      , KC_K          , KC_L    , KC_SCLN , KC_QUOT,
 KC_LSFT       , KC_Z    ,         KC_X    , KC_C    , KC_V           , KC_B                  , KC_N                 , KC_M               , KC_COMM          , KC_DOT  , KC_SLSH , KC_RSFT,
 MO(_ADJUST)   , KC_LCTL , 
        KC_LALT ,   
        KC_LGUI ,                LT(_LOWER, KC_ENT) ,
        LT(_SHIFTED, KC_TAB)   , LT(_ARROWS, KC_BSPC) , LT(_LOWER, KC_SPC)               , ALT_T(KC_ESC)          , KC_LALT ,           KC_LCTL , MO(_ARROWS)
),

[_OTHER] = LAYOUT_preonic_grid(
     KC_ESC        , KC_1    , KC_2 , KC_3    , KC_4               , KC_5                  , KC_6      
        , KC_7               , KC_8          , KC_9    , KC_0    , KC_F12,
 KC_TAB        , KC_Q    , KC_W    , KC_E    , KC_R               , KC_T               , KC_Y                 , KC_U               , KC_I          , KC_O    , KC_P    , KC_ENT,
 CTL_T(KC_ESC) ,     
        KC_A    , KC_S    , KC_D    , KC_F            , KC_G                  , KC_H                 , KC_J                      , KC_K          , KC_L    , KC_SCLN , KC_QUOT, KC_LSFT       , KC_Z    ,         KC_X    , KC_C    , KC_V           , KC_B                  , KC_N                 , KC_M               , KC_COMM          , KC_DOT  , KC_SLSH , KC_RSFT,
 MO(_ADJUST)   , KC_LCTL , 
        KC_LALT ,   
        KC_LGUI ,                LT(_LOWER, KC_ENT) ,
        LT(_SHIFTED, KC_TAB)   , LT(_ARROWS, KC_BSPC) , LT(_LOWER, KC_SPC)               , ALT_T(KC_ESC)          , KC_LALT ,           KC_LCTL , MO(_ARROWS)
),
};
