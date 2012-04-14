require 'spec_helper'

describe ConteudosController do
  include ControllerAuth

  before :each do
    autorizar_tudo
    login Factory.create(:usuario_contribuidor)
  end

  describe 'GET new' do
    it 'define um atributo @conteudo como um novo ArtigoDeEvento' do
      get :new, tipo: :artigo_de_evento
      conteudo = assigns[:conteudo]
      conteudo.should_not be_nil
      conteudo.should be_new_record
      conteudo.should be_kind_of(ArtigoDeEvento)
    end
  end
end
