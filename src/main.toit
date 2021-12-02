import gpio

stp_pin := gpio.Pin.out 15
dir_pin := gpio.Pin.out 16
ms1_pin := gpio.Pin.out 17
ms2_pin := gpio.Pin.out 18
en_pin := gpio.Pin.out 19

main:
  driver := A3967 --stp_pin=stp_pin --dir_pin=dir_pin --ms1_pin=ms1_pin --ms2_pin=ms2_pin --en_pin=en_pin
  driver.reset
  driver.set_step_resolution A3967.EIGHT_STEP
  driver.rotate

class A3967:

  static FULL_STEP ::= 0b00
  static HALF_STEP ::= 0b10
  static QUARTER_STEP ::= 0b01
  static EIGHT_STEP ::= 0b11

  static CLOCKWISE ::= 0
  static COUNTER_CLOCKWISE ::= 1

  static MS1_MASK_ ::= 0b01
  static MS2_MASK_ ::= 0b10

  stp_pin_/gpio.Pin
  dir_pin_/gpio.Pin
  ms1_pin_/gpio.Pin
  ms2_pin_/gpio.Pin
  en_pin_/gpio.Pin

  constructor
      --stp_pin/gpio.Pin
      --dir_pin/gpio.Pin
      --ms1_pin/gpio.Pin
      --ms2_pin/gpio.Pin
      --en_pin/gpio.Pin:
    stp_pin_ = stp_pin
    dir_pin_ = dir_pin
    ms1_pin_ = ms1_pin
    ms2_pin_ = ms2_pin
    en_pin_ = en_pin

  reset:
    stp_pin_.set 0
    dir_pin_.set 0
    ms1_pin_.set 0
    ms2_pin_.set 0
    en_pin_.set  1

  enable_:
    en_pin_.set  0

  disable_:
    en_pin_.set  1

  step:
    stp_pin_.set 1
    sleep --ms=1
    stp_pin_.set 0
    sleep --ms=1

  rotate --duration/Duration?=null:
    try:
      enable_
      catch:
        with_timeout duration:
          while true:
            step
    finally:
      disable_

  set_direction direction/int:
    dir_pin_.set
      direction > 0 ? 1 : 0

  set_step_resolution resolution/int:
    ms1_pin_.set resolution & MS1_MASK_
    ms2_pin_.set (resolution & MS2_MASK_) >> 1
