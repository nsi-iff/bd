require 'spec_helper'

describe 'action controller extension' do
  class RichRockSunshine; end

  class RichRockSunshinesController < ActionController::Base
  end

  let(:controller) { RichRockSunshinesController.new }

  it 'descobre a classe de model correspondente' do
    controller.send(:model_class).should == RichRockSunshine
  end

  it 'descobre o identificador para um objeto model' do
    controller.send(:model_object_name).should == 'rich_rock_sunshine'
  end
end

