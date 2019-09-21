require 'spec_helper'

RSpec.describe Onvif::DeviceService do
  subject(:device_service) { described_class.new(camera) }

  let(:camera) { { url: 'http://example.com', username: 'CornPop', password: 'pomade' } }

  describe '#url' do
    it 'returns the full path to the device service' do
      expect(device_service.url).to eq("#{camera[:url]}/onvif/device_service")
    end
  end
end
