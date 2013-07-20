# Copyright (C) 2013  Michal Papis <mpapis@gmail.com>
# License text: GNU-AGPL-3.0.txt

module MsiEpf
  class Device
    module Mode
      MODE_BLINK  = 0x01
      MODE_AUDIO  = 0x02
      MODE_BREATH = 0x03
      MODE_DEMO   = 0x04
      MODE_ALWAYS = 0x05

      def mode_to_value(mode)
        case mode
        when :disabled then [0, 0]
        when :blink    then [MODE_BLINK,  1]
        when :audio    then [MODE_AUDIO,  1]
        when :breath   then [MODE_BREATH, 1]
        when :demo     then [MODE_DEMO,   1]
        when :always   then [MODE_ALWAYS, 1]
        else raise "unknown mode #{mode}"
        end
      end

      def value_to_mode(value)
        value_mode, value_enabled = value[3,4].each_byte.to_a
        return :disabled if value_enabled == 0
        case value_mode
        when MODE_BLINK  then :blink
        when MODE_AUDIO  then :audio
        when MODE_BREATH then :breath
        when MODE_DEMO   then :demo
        when MODE_ALWAYS then :always
        else raise "unknown value #{value_mode.class}:#{value_mode} - #{value_enabled}"
        end
      end

      def mode=(mode)
        value_to_mode run_control_request(0x01, 0x02, 0x20, *mode_to_value(mode))
      end

      def mode
        value_to_mode run_control_request(0x01, 0x01, 0x10)
      end

    end
  end
end
