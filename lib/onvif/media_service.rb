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
  end
end
