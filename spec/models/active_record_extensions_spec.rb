# encoding: utf-8

require 'spec_helper'

describe 'action record extensions' do
  it 'informa o nome da coleção correspondente' do
    ArtigoDeEvento.new.send(:object_collection_name).should == 'artigos_de_evento'
  end
end
