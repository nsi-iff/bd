# encoding: utf-8

require 'spec_helper'

describe Arquivo do
  it 'informa se é um ODT' do
    Arquivo.new(nome: 'nao_sou_odt.nao').should_not be_odt
    Arquivo.new(nome: 'eu_sou.odt').should be_odt
    Arquivo.new(nome: 'eu_nao_sou_odt').should_not be_odt
    Arquivo.new(nome: 'eu_sou.ODT').should be_odt
  end

  it 'informa se é um video' do
    arquivo = Arquivo.create nome: :nome, conteudo: create(:conteudo), mime_type: 'video/ogg'
    arquivo.video?.should be_true
    arquivo = Arquivo.create nome: :nome, conteudo: create(:conteudo), mime_type: 'text/plain'
    arquivo.video?.should be_false
  end
end

