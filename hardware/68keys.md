# Configuring and installing firmware for MF68 keyboard, structured as shown on 68keys.io

## Hardware:
QWiic Pro Micro USB-C (DEV-15795)

## Setup & Firmware:
Prepare build environment:  
`zypper install avr-{gcc,libc}`  
git clone qmk repo  
copy 40percentclub/mf68/default to 40percentclub/mf68/cyril  
edit cyril/keymap.c as desired (see 'layout' below)  

from root of git project:  
`make 40percentclub/mf68:cyril #to compile`  
`make 40percentclub/mf68:cyril:dfu #to install`  

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

Sample output:
```
cyril@ten:~/workshop/qmk_firmware> make 40percentclub/mf68:cyril
QMK Firmware 0.8.150
Making 40percentclub/mf68 with keymap cyril

make[1]: Entering directory '/home/cyril/workshop/qmk_firmware'
avr-gcc (SUSE Linux) 10.0.1 20200302 (experimental) [revision 778a77357cad11e8dd4c810544330af0fbe843b1]
Copyright (C) 2020 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Compiling: keyboards/40percentclub/mf68/mf68.c                                                      [OK]
Compiling: keyboards/40percentclub/mf68/keymaps/cyril/keymap.c                                      [OK]
Compiling: quantum/quantum.c                                                                        [OK]
Compiling: quantum/keymap_common.c                                                                  [OK]
Compiling: quantum/keycode_config.c                                                                 [OK]
Compiling: quantum/matrix_common.c                                                                  [OK]
Compiling: quantum/matrix.c                                                                         [OK]
Compiling: quantum/debounce/sym_g.c                                                                 [OK]
Compiling: quantum/backlight/backlight.c                                                            [OK]
Compiling: quantum/process_keycode/process_backlight.c                                              [OK]
Compiling: quantum/backlight/backlight_driver_common.c                                              [OK]
Compiling: quantum/backlight/backlight_avr.c                                                        [OK]
Compiling: quantum/process_keycode/process_space_cadet.c                                            [OK]
Compiling: quantum/process_keycode/process_magic.c                                                  [OK]
Compiling: quantum/process_keycode/process_grave_esc.c                                              [OK]
Compiling: tmk_core/common/host.c                                                                   [OK]
Compiling: tmk_core/common/keyboard.c                                                               [OK]
Compiling: tmk_core/common/action.c                                                                 [OK]
Compiling: tmk_core/common/action_tapping.c                                                         [OK]
Compiling: tmk_core/common/action_macro.c                                                           [OK]
Compiling: tmk_core/common/action_layer.c                                                           [OK]
Compiling: tmk_core/common/action_util.c                                                            [OK]
Compiling: tmk_core/common/print.c                                                                  [OK]
Compiling: tmk_core/common/debug.c                                                                  [OK]
Compiling: tmk_core/common/sendchar_null.c                                                          [OK]
Compiling: tmk_core/common/util.c                                                                   [OK]
Compiling: tmk_core/common/eeconfig.c                                                               [OK]
Compiling: tmk_core/common/report.c                                                                 [OK]
Compiling: tmk_core/common/avr/suspend.c                                                            [OK]
Compiling: tmk_core/common/avr/timer.c                                                              [OK]
Compiling: tmk_core/common/avr/bootloader.c                                                         [OK]
Assembling: tmk_core/common/avr/xprintf.S                                                           [OK]
Compiling: tmk_core/common/magic.c                                                                  [OK]
Compiling: tmk_core/common/mousekey.c                                                               [OK]
Compiling: tmk_core/protocol/lufa/lufa.c                                                            [OK]
Compiling: tmk_core/protocol/usb_descriptor.c                                                       [OK]
Compiling: tmk_core/protocol/lufa/outputselect.c                                                    [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Class/Common/HIDParser.c                                       [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/AVR8/Device_AVR8.c                                        [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/AVR8/EndpointStream_AVR8.c                                [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/AVR8/Endpoint_AVR8.c                                      [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/AVR8/Host_AVR8.c                                          [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/AVR8/PipeStream_AVR8.c                                    [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/AVR8/Pipe_AVR8.c                                          [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/AVR8/USBController_AVR8.c                                 [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/AVR8/USBInterrupt_AVR8.c                                  [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/ConfigDescriptors.c                                       [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/DeviceStandardReq.c                                       [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/Events.c                                                  [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/HostStandardReq.c                                         [OK]
Compiling: lib/lufa/LUFA/Drivers/USB/Core/USBTask.c                                                 [OK]
Linking: .build/40percentclub_mf68_cyril.elf                                                        [WARNINGS]
 | 
 | /usr/lib64/gcc/avr/10/ld: warning: -z relro ignored
 | 
Creating load file for flashing: .build/40percentclub_mf68_cyril.hex                                [OK]
Copying 40percentclub_mf68_cyril.hex to qmk_firmware folder                                         [OK]
Checking file size of 40percentclub_mf68_cyril.hex                                                  [OK]
 * The firmware size is fine - 18412/28672 (64%, 10260 bytes free)
make[1]: Leaving directory '/home/cyril/workshop/qmk_firmware'
cyril@ten:~/workshop/qmk_firmware>
```

More detail shown at 68keys.io and 40percent.club  
https://68keys.io/  
https://deskthority.net/viewtopic.php?t=20616  
http://www.40percent.club/2016/11/mf68-revised-pcb.html  
Keycodes and firmware:  
https://beta.docs.qmk.fm/using-qmk/simple-keycodes/keycodes  
