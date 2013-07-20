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
      SUPPORTED_STATE = {
        :disabled => 0,
        :enabled  => 1,
      }

      # setting :disabled also does state=:disabled,
      # setting actve mode after disabled does state=:enabled
      def mode=(_mode)
        mode_state[1] = 1 if mode_state[1] == 0 && mode_state[0] == 0 && _mode != :disabled
        @mode_state = run_mode_request(0x01, 0x02, 0x20, mode_to_value(_mode), mode_state[1])
        mode
      end

      def mode
        value_to_mode(mode_state[0])
      end

      # control state without changing mode
      def state=(_state)
        @mode_state = run_mode_request(0x01, 0x02, 0x20, mode_state[0], state_to_value(_state))
        state
      end

      def state
        value_to_state(mode_state[1])
      end

    private

      def mode_to_value(_mode)
        SUPPORTED_MODES[_mode] or raise "unknown mode #{_mode}"
      end

      def value_to_mode(value)
        SUPPORTED_MODES.key(value) or raise "unknown mode value #{value}"
      end

      def state_to_value(_enabled)
        SUPPORTED_STATE[_enabled] or raise "unknown enabled #{_enabled}"
      end

      def value_to_state(value)
        SUPPORTED_STATE.key(value) or raise "unknown enabled value #{value}"
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
