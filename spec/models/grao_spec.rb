# encoding: utf-8

require 'spec_helper'

describe Grao do
  it 'responde se é do tipo arquivo' do
    Grao.new(tipo: 'files').should be_arquivo
    Grao.new(tipo: 'outra coisa').should_not be_arquivo
  end

  it 'responde se é do tipo imagem' do
    Grao.new(tipo: 'images').should be_imagem
    Grao.new(tipo: 'outra coisa').should_not be_imagem
  end
end
