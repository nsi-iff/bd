require 'spec_helper'
require 'open-uri'
require 'json'

describe 'integration test configuration' do
  it 'works!' do
    JSON(URI.parse('http://localhost:9999?key=123').read).should == {
      'metadata' => 'something',
      'data' => 'the thing you\'ve requested using "123"' }
  end
end
