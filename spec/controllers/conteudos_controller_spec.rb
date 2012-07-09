require 'spec_helper'

describe ConteudosController do
  include ControllerAuth

  before :each do
    autorizar_tudo
    login create(:usuario_contribuidor)
  end

  describe 'GET new' do
    before(:each) do
      get :new, tipo: :artigo_de_evento
      @conteudo = assigns[:conteudo]
    end

    it 'define um atributo @conteudo como um novo ArtigoDeEvento' do
      @conteudo.should_not be_nil
      @conteudo.should be_new_record
      @conteudo.should be_kind_of(ArtigoDeEvento)
    end

    it 'inclui um autor em @conteudo' do
      @conteudo.should have(1).autores
    end

    it "instancia um arquivo em @conteudo" do
      @conteudo.arquivo.should_not be_nil
      @conteudo.arquivo.should be_new_record
    end
  end
end
