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
  
  describe 'limitar_para_portlet' do
    before(:each) do
      Rails.application.config.limite_de_itens_nos_portlets = 3
    end
    
    it 'retorna apenas o numero de itens definido na configuracao' do
      helper.limitar_para_portlet((1..10).to_a).should == [1, 2, 3]
    end
    
    it 'permite retornar os ultimos em vez dos primeiros' do
      helper.limitar_para_portlet((1..10).to_a, reverse: true).should == 
        [10, 9, 8]
    end
  end
end
