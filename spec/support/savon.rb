require 'savon/mock/spec_helper'

def use_real_camera
  value = ENV['USE_REAL_CAMERA'] || ''
  @use_real_camera ||= value.downcase == 'true' || false
end

module Onvif
  module RealCamera
    def real_camera
      return if use_real_camera == false

      @real_camera ||= {
        url: ENV['CAMERA_URL'],
        username: ENV['CAMERA_USERNAME'],
        password: ENV['CAMERA_PASSWORD']
      }
    end
  end

  module NullSavonSpecHelper
    class Interface
      def expects(operation_name)
        NullExpectation.new
      end
    end

    class NullExpectation
      def returns(expectation); end
    end

    def savon
      @savon ||= Interface.new
    end
  end
end

RSpec.configure do |config|
  config.include Savon::SpecHelper, savon: true
  config.before(:each, savon: true) { savon.mock! }
  config.after(:each, savon: true)  { savon.unmock! }
end unless use_real_camera

RSpec.configure do |config|
  config.include Onvif::NullSavonSpecHelper, savon: true
end if use_real_camera

RSpec.configure do |config|
  config.include Onvif::RealCamera, savon: true
end

puts '***********************************' if use_real_camera
puts '*** Running in Real Camera mode ***' if use_real_camera
puts '***********************************' if use_real_camera
