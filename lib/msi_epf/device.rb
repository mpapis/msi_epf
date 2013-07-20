# Copyright (C) 2013  Michal Papis <mpapis@gmail.com>
# License text: GNU-AGPL-3.0.txt

require "libusb"
require_relative 'device/info'
require_relative 'device/leds'
require_relative 'device/mode'

module MsiEpf
  class Device
    LIBUSB_ENDPOINT_IN         = 0x80
    LIBUSB_ENDPOINT_OUT        = 0x00
    LIBUSB_RECIPIENT_INTERFACE = 0x01
    LIBUSB_REQUEST_TYPE_CLASS  = 0x01 << 5
    LIBUSB_REQUEST_CLEAR_FEATURE     = 0x01
    LIBUSB_REQUEST_SET_CONFIGURATION = 0x09

    VENDOR_ID  = 0x1770
    PRODUCT_ID = 0xFF00
    CONFIG_VALUE = 0x301
    CONFIG_INDEX = 0x00
    CONFIG_REQUEST_TYPE_IN  = (LIBUSB_ENDPOINT_IN  | LIBUSB_REQUEST_TYPE_CLASS | LIBUSB_RECIPIENT_INTERFACE)
    CONFIG_REQUEST_TYPE_OUT = (LIBUSB_ENDPOINT_OUT | LIBUSB_REQUEST_TYPE_CLASS | LIBUSB_RECIPIENT_INTERFACE)

    attr_reader :device
    include Info
    include Leds
    include Mode

    def initialize
      usb = LIBUSB::Context.new
      @device = usb.devices(:idVendor => VENDOR_ID, :idProduct => PRODUCT_ID).first
    end

    def handle
      open if @handle.nil?
      @handle
    end

    def open(&block)
      @handle = @device.open
      @handle.claim_interface(0)
      if block_given?
        begin
          yield self
        ensure
          close
        end
      end
    end

    def close
      @handle.release_interface(0)
      @handle.close
    ensure
      @handle = @device = nil
    end

  private

    def send_control_request(args = {})
      handle.control_transfer(
        args.merge({
          :wValue => CONFIG_VALUE,
          :wIndex => CONFIG_INDEX,
        })
      )
    end

    def write_request(data)
      send_control_request(
        :bmRequestType => CONFIG_REQUEST_TYPE_OUT,
        :bRequest => LIBUSB_REQUEST_SET_CONFIGURATION,
        :dataOut => data
      )
    end

    def read_result
      send_control_request(
        :bmRequestType => CONFIG_REQUEST_TYPE_IN,
        :bRequest => LIBUSB_REQUEST_CLEAR_FEATURE,
        :dataIn => 8
      )
    end

    # fill in to 8 bytes, convert to string of chars
    def build_data_string(*arr)
      arr+=[0,0,0,0,0,0,0,0]
      arr[0..7].map{|c| c.chr}.join('')
    end

    def run_control_request(*args)
      write_request(build_data_string(*args))
      read_result
    end

  end
end
