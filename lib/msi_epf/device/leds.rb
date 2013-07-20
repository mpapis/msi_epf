# Copyright (C) 2013  Michal Papis <mpapis@gmail.com>
# License text: GNU-AGPL-3.0.txt

module MsiEpf
  class Device
    module Leds
      SUPPORTED_LEDS = {
        :back  => 0x01,
        :side  => 0x02,
        :front => 0x04,
      }

      def leds=(leds = [])
        value_to_leds run_control_request(0x01, 0x02, 0x30, leds_to_value(leds))
      end

      def leds
        raise "do not know how to do that :("
      end

    private

      def leds_to_value(leds = [])
        unsupported_leds = leds.reject{|led| SUPPORTED_LEDS.keys.include?(led)}
        unless unsupported_leds.empty?
          raise "unsupported led type #{unsupported_leds.map{|led| "'#{led}'"}.join(", ")}"
        end
        leds.map{|led| SUPPORTED_LEDS[led]}.inject(&:|)
      end

      def value_to_leds(value)
        value = value[3].unpack('C')[0]
        unless SUPPORTED_LEDS.values.inject(&:|) & value == value
          raise "unsupported led value #{SUPPORTED_LEDS.values.inject(&:|) ^ value}"
        end
        SUPPORTED_LEDS.map{|led, val| value & val == val ? led : nil}.compact
      end

    end
  end
end
