# Copyright (C) 2013  Michal Papis <mpapis@gmail.com>
# License text: GNU-AGPL-3.0.txt

module MsiEpf
  class Device
    module Info
      def name
        handle.string_descriptor_ascii(device.configurations[0].bConfigurationValue)
      end

      def version
        run_control_request(0x01, 0x10)[2..7]
      end

      def dump
        (0..0xff).each{|x|
          result = run_control_request 0x01, 0x01, x
          puts "%-2x: %3s, %3s, %3s, %3s, %3s, %3s, %3s, %3s" % ([x] + result.each_byte.map{|c|c.to_s})
        }
      end

      def run_custom(*args)
        puts "running: #{args.map{|c|"%3s" % c.to_s}*", "}"
        result = run_control_request *args
        puts "result : #{result.each_byte.map{|c|"%3s" % c.to_s}*", "}"
      end

      def tree
        Hash[device.configurations.map{|c|
          [c.inspect,Hash[c.interfaces.map{|i|
            [i.inspect, Hash[i.settings.map{|s|
              [s.inspect, s.endpoints.map{|e| e.inspect}]
            }]]
          }]]
        }]
      end

    end
  end
end
