require 'spec_helper'
require 'savon/mock/spec_helper'

RSpec.describe Onvif::MediaService do
  include Savon::SpecHelper

  subject(:media_service) { described_class.new(camera, device_service) }

  let(:capabilities_path) { File.join('spec', 'fixtures', 'device_service', 'get_capabilities.xml') }
  let(:capabilities) { File.read(capabilities_path) }
  let(:profiles_path) { File.join('spec', 'fixtures', 'media_service', 'get_profiles.xml') }
  let(:profiles) { File.read(profiles_path) }
  let(:camera) { { url: 'http://example.com', username: 'CornPop', password: 'pomade' } }
  let(:device_service) { Onvif::DeviceService.new(camera) }

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  describe '#url' do
    before { savon.expects(:get_capabilities).returns(capabilities) }

    it 'returns the full path to the media service' do
      expect(media_service.url).to eq("#{camera[:url]}/onvif/media_service")
    end
  end

  describe '#wsdl_path' do
    it 'returns a path to the media service wsdl' do
      expect(media_service.wsdl_path).to eq(File.expand_path(File.join('config', 'media.wsdl')))
    end
  end

  describe '#profiles' do
    before do
      savon.expects(:get_capabilities).returns(capabilities)
      savon.expects(:get_profiles).returns(profiles)
    end

    it 'returns the media profiles' do
      expect(media_service.profiles.map { |profile| profile[:name] }).to include('MediaProfile_Channel1_MainStream', 'MediaProfile_Channel1_SubStream1')
    end
  end
end
