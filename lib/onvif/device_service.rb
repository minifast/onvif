require 'savon'

module Onvif
  class DeviceService
    attr_reader :camera

    def initialize(camera)
      @camera = camera
    end

    def url
      uri = URI(camera[:url])
      uri.path = device_service_path
      uri.to_s
    end

    def wsdl_path
      File.expand_path(File.join('config', 'devicemgmt.wsdl'))
    end

    def header
      Akami.wsse.tap do| wsse|
        wsse.credentials(camera[:username], camera[:password], true)
      end.to_xml
    end

    def get_device_information
      client.call(:get_device_information, soap_header: header).body.dig(:get_device_information_response)
    end

    def get_capabilities
      client.call(:get_capabilities, soap_header: header).body.dig(:get_capabilities_response, :capabilities)
    end

    private

    def client
      @client ||= Savon.client(endpoint: url, wsdl: wsdl_path, soap_version: 2)
    end

    def device_service_path
      '/onvif/device_service'
    end
  end
end
