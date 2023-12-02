#include QMK_KEYBOARD_H

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
        switch (keycode) {
                case LGUI_T(KC_A):
                case RGUI_T(KC_SCLN):
                case LALT_T(KC_S):
                case RALT_T(KC_L):
                        return TAPPING_TERM + 80;
                        break;
                case LCTL_T(KC_D):
                case RCTL_T(KC_K):
                        return TAPPING_TERM + 50;
                        break;
                case LT(1,KC_SPC):
                case LT(4,KC_ESC):
                case LT(3,KC_BSPC):
                case LT(2,KC_ENT):
                        return TAPPING_TERM - 40;
                        break;
                case LSFT_T(KC_F):
                case RSFT_T(KC_J):
                        return TAPPING_TERM - 60;
                        break;
                default:
                        return TAPPING_TERM;
}}

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
        [0] = LAYOUT_split_3x5_2(KC_Q, KC_W, KC_E, KC_R, KC_T, KC_Y, KC_U, KC_I, KC_O, KC_P, LGUI_T(KC_A), LALT_T(KC_S), LCTL_T(KC_D), LSFT_T(KC_F), KC_G, KC_H, RSFT_T(KC_J), RCTL_T(KC_K), RALT_T(KC_L), RGUI_T(KC_SCLN), KC_Z, KC_X, KC_C, KC_V, KC_B, KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, LT(1,KC_SPC), LT(4,KC_ESC), LT(3,KC_BSPC), LT(2,KC_ENT)),
        [1] = LAYOUT_split_3x5_2(KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_MS_L, KC_MS_D, KC_MS_U, KC_MS_R, KC_NO, KC_LGUI, KC_LALT, KC_LCTL, KC_LSFT, KC_NO, KC_LEFT, KC_DOWN, KC_UP, KC_RGHT, KC_QUOT, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_WH_L, KC_WH_D, KC_WH_U, KC_WH_R, CW_TOGG, KC_NO, KC_NO, KC_BTN1, KC_BTN2),
        [2] = LAYOUT_split_3x5_2(KC_LBRC, KC_7, KC_8, KC_9, KC_RBRC, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_TAB, KC_4, KC_5, KC_6, KC_EQL, KC_NO, KC_RSFT, KC_RCTL, KC_RALT, KC_RGUI, KC_GRV, KC_1, KC_2, KC_3, KC_BSLS, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_0, KC_MINS, KC_NO, KC_NO),
        [3] = LAYOUT_split_3x5_2(KC_LCBR, KC_AMPR, KC_ASTR, KC_LPRN, KC_RCBR, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_TAB, KC_DLR, KC_PERC, KC_CIRC, KC_PLUS, KC_NO, KC_RSFT, KC_RCTL, KC_RALT, KC_RGUI, KC_TILD, KC_EXLM, KC_AT, KC_HASH, KC_PIPE, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_RPRN, KC_UNDS, KC_NO, KC_NO),
        [4] = LAYOUT_split_3x5_2(KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_TAB, KC_LBRC, KC_LCBR, KC_LPRN, KC_NO, KC_NO, KC_RPRN, KC_RCBR, KC_RBRC, KC_DQUO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO)
};

#if defined(ENCODER_ENABLE) && defined(ENCODER_MAP_ENABLE)
const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][NUM_DIRECTIONS] = {

};
#endif // defined(ENCODER_ENABLE) && defined(ENCODER_MAP_ENABLE)
