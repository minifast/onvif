require 'spec_helper'
require 'savon/mock/spec_helper'

RSpec.describe Onvif::DeviceService do
  include Savon::SpecHelper

  subject(:device_service) { described_class.new(camera) }

  let(:device_information_path) { File.join('spec', 'fixtures', 'device_service', 'get_device_information.xml') }
  let(:device_information) { File.read(device_information_path) }
  let(:capabilities_path) { File.join('spec', 'fixtures', 'device_service', 'get_capabilities.xml') }
  let(:capabilities) { File.read(capabilities_path) }
  let(:system_date_and_time_path) { File.join('spec', 'fixtures', 'device_service', 'get_system_date_and_time.xml') }
  let(:system_date_and_time) { File.read(system_date_and_time_path) }
  let(:camera) { { url: 'http://example.com', username: 'CornPop', password: 'pomade' } }

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  describe '#url' do
    it 'returns the full path to the device service' do
      expect(device_service.url).to eq("#{camera[:url]}/onvif/device_service")
    end
  end

  describe '#wsdl_path' do
    it 'returns a path to the device service wsdl' do
      expect(device_service.wsdl_path).to eq(File.expand_path(File.join('config', 'devicemgmt.wsdl')))
    end
  end

  describe '#header' do
    it 'returns' do
      expect(device_service.header).to include('wsu:Created')
    end
  end

  describe '#get_device_information' do
    before { savon.expects(:get_device_information).returns(device_information) }

    it 'returns device information' do
      expect(device_service.get_device_information).to include(:manufacturer, :model, :serial_number, :hardware_id, :firmware_version)
    end
  end

  describe '#get_capabilities' do
    before { savon.expects(:get_capabilities).returns(capabilities) }

    it 'returns device capabilities' do
      expect(device_service.get_capabilities).to include(:media, :ptz)
    end
  end

  describe '#media_service_path' do
    before { savon.expects(:get_capabilities).returns(capabilities) }

    it 'returns the media service path' do
      expect(device_service.media_service_path).to eq('/onvif/media_service')
    end
  end

  describe '#get_system_date_and_time' do
    before { savon.expects(:get_system_date_and_time).returns(system_date_and_time) }

    it 'returns the camera date and time' do
      expect(device_service.get_system_date_and_time.map { |k, _v| k }).to include(:utc_date_time, :local_date_time)
    end
  end
end
