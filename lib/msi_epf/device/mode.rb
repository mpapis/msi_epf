# Copyright (C) 2013  Michal Papis <mpapis@gmail.com>
# License text: GNU-AGPL-3.0.txt

module MsiEpf
  class Device
    module Mode
      SUPPORTED_MODES = {
        :disabled => 0,
        :blink    => 1,
        :audio    => 2,
        :breath   => 3,
        :demo     => 4,
        :always   => 5,
      }
      SUPPORTED_ENABLED = {
        false => 0,
        true  => 1,
      }

      def mode=(_mode)
        @mode_state = run_mode_request(0x01, 0x02, 0x20, mode_to_value(_mode), mode_state[1])
      end

      def mode
        value_to_mode(mode_state[0])
      end

      def enabled=(_enabled)
        @mode_state = run_mode_request(0x01, 0x02, 0x20, mode_state[0], enabled_to_value(_enabled))
        enabled
      end

      def enabled
        value_to_enabled(mode_state[1])
      end

    private

      def mode_to_value(mode)
        SUPPORTED_MODES[mode] or raise "unknown mode #{mode}"
      end

      def value_to_mode(value)
        SUPPORTED_MODES.key(value) or raise "unknown mode value #{value}"
      end

      def enabled_to_value(enabled)
        SUPPORTED_ENABLED[enabled] or raise "unknown enabled #{enabled}"
      end

      def value_to_enabled(value)
        SUPPORTED_ENABLED.key(value) or raise "unknown enabled value #{enabled}"
      end

      def run_mode_request(*args)
        run_control_request(*args)[3..4].each_byte.to_a
      end

      def mode_state
        @mode_state ||= run_mode_request(0x01, 0x01, 0x10)
      end

    end
  end
end
