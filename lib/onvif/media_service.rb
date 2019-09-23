require 'savon'

module Onvif
  class MediaService
    attr_reader :camera, :device_service

    def initialize(camera, device_service)
      @camera = camera
      @device_service = device_service
    end

    def url
      uri = URI(camera[:url])
      uri.path = device_service.media_service_path
      uri.to_s
    end

    def wsdl_path
      File.expand_path(File.join('config', 'media.wsdl'))
    end

    def profiles
      client.call(:get_profiles, soap_header: device_service.header).body.dig(:get_profiles_response, :profiles)
    end

    private

    def client
      @client ||= Savon.client(endpoint: url, wsdl: wsdl_path, soap_version: 2)
    end
  end
end
