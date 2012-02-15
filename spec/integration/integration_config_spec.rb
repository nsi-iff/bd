require 'spec_helper'
require 'open-uri'
require 'json'

describe 'integration test configuration' do
  it 'works!' do
    config = Rails.application.config
    JSON(URI.parse("#{config.sam_uri}:#{config.sam_port}?key=123").read).should == {
      'metadata' => 'something',
      'data' => 'the thing you\'ve requested using "123"' }
  end
end
