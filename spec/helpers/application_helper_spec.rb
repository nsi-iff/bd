# encoding: utf-8

require 'spec_helper'

describe ApplicationHelper do
  describe 'geração de título' do
    let(:titulo_base) { "Biblioteca Digital da EPCT" }

    context 'sem @title' do
      it 'retorna o título base' do
        helper.title.should == titulo_base
      end
    end

    context 'com @title' do
      before(:each) { helper.instance_eval { @title = 'dummy' } }

      it 'concatena o @title com o título base' do
        helper.title.should == "dummy | #{titulo_base}"
      end
    end
  end

  describe 'conteudo_tag' do
    it 'produz um span com as classes "conteudo" e tipo do conteudo' do
      helper.conteudo_tag(
        ObjetoDeAprendizagem.new(titulo: "Hey ho, let's go")).should ==
        "<span class='conteudo_tag conteudo-objeto_de_aprendizagem'>Hey ho, let's go</span>"
    end
  end
end
