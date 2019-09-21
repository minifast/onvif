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

    private

    def device_service_path
      '/onvif/device_service'
    end
  end
end
