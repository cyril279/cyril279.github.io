# Configuring and installing firmware for MF68 keyboard, structured as shown on 68keys.io

## Hardware:
QWiic Pro Micro USB-C (DEV-15795)

## Setup & Firmware:
Prepare build environment:
`zypper install avr-{gcc,libc}`
git clone qmk repo
copy 40percentclub/mf68/default to 40percentclub/mf68/cyril
edit keymap.c as desired (see 'layout' below)

from root of git project:
make 40percentclub/mf68:cyril #to compile
make 40percentclub/mf68:cyril:dfu #to install

## Layout:
```
#include QMK_KEYBOARD_H

#define _QWERTY 0
#define _FN1 1

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [_QWERTY] = LAYOUT_68_ansi(
    KC_GESC, KC_1,    KC_2,    KC_3,    KC_4,    KC_5,    KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS, KC_EQL,  KC_BSPC,          KC_INS,  KC_HOME,
    KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_LBRC, KC_RBRC, KC_BSLS,          KC_DEL,  KC_END,
    KC_CAPS, KC_A,    KC_S,    KC_D,    KC_F,    KC_G,    KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,          KC_ENT,
    KC_LSFT, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,    KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH,                   KC_RSFT,          KC_UP,
    KC_LCTL, KC_LGUI, KC_LALT,                            KC_SPC,                             KC_RALT, MO(1),   KC_RCTL,          KC_LEFT, KC_DOWN, KC_RGHT
  ),
  [_FN1] = LAYOUT_68_ansi(
    KC_GRV,  KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12,  KC_BSPC,          KC_VOLU, KC_PGUP,
    _______, _______, _______, KC_UP,   _______, _______, _______, _______, _______, _______, KC_PSCR, _______, BL_STEP, _______,          KC_VOLD, KC_PGDN,
    _______, _______, KC_LEFT, KC_DOWN, KC_RGHT, _______, _______, _______, _______, _______, _______, _______,          _______,
    _______, _______, _______, _______, _______, _______, _______, KC_MUTE, _______, _______, _______,                   _______,          KC_MUTE,
    _______, _______, _______,                            _______,                            _______, _______, _______,          KC_MPRV, KC_MPLY, KC_MNXT
  )
};
```

More detail shown at 68keys.io and 40percent.club
https://68keys.io/
https://deskthority.net/viewtopic.php?t=20616
http://www.40percent.club/2016/11/mf68-revised-pcb.html
Keycodes and firmware
https://beta.docs.qmk.fm/using-qmk/simple-keycodes/keycodes
