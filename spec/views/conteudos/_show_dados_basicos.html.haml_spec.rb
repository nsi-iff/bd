#encoding: utf-8

require 'spec_helper'

describe "conteudos/_show_dados_basicos.html.haml" do
  before :each do
    Papel.criar_todos
  end

  describe 'botão de download' do
    before(:each) do
      view.stub(:can?).and_return(true)
      @conteudo = create(:relatorio_publicado)
      view.stub(:conteudo).and_return(@conteudo)
      sign_in :usuario, create(:usuario_gestor)
    end
    
    it 'aparece para documentos disponiveis para download' do
      @conteudo.stub(:disponivel_para_download?).and_return(true)
      render
      rendered.should have_button 'Download'
    end
    
    it 'nao aparece para documentos nao disponiveis para download' do
      @conteudo.stub(:disponivel_para_download?).and_return(false)
      render
      rendered.should_not have_button 'Download'
    end
  end
end
