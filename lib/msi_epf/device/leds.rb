# Copyright (C) 2013  Michal Papis <mpapis@gmail.com>
# License text: GNU-AGPL-3.0.txt

module MsiEpf
  class Device
    module Leds
      LEDS_BACK  = 0x01
      LEDS_SIDE  = 0x02
      LEDS_FRONT = 0x04
      LEDS_ALL   = LEDS_BACK | LEDS_SIDE | LEDS_FRONT

      def leds_to_value(leds = [])
        value = 0
        value |= LEDS_BACK  if leds.include? :back
        value |= LEDS_SIDE  if leds.include? :side
        value |= LEDS_FRONT if leds.include? :front
        value |= LEDS_ALL   if leds.include? :all
        value
      end

      def value_to_leds(value)
        leds = []
        value = value[3].unpack('C')[0]
        leds << :back  if value & LEDS_BACK  == LEDS_BACK
        leds << :side  if value & LEDS_SIDE  == LEDS_SIDE
        leds << :front if value & LEDS_FRONT == LEDS_FRONT
        leds
      end

      def leds=(leds = [])
        value_to_leds run_control_request(0x01, 0x02, 0x30, leds_to_value(leds))
      end

      def leds_get
        raise "do not know how to do that :("
      end

    end
  end
end
