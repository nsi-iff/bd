require 'spec_helper'

describe ArtigosDeEventoController, "incluindo modulo NovoComAutor" do
  include ControllerAuth

  before :each do
    autorizar_tudo
    login Factory.create(:usuario_contribuidor)
  end

  describe 'new' do
    it 'define um atributo @artigo_de_evento como um novo ArtigoDeEvento' do
      get :new
      assigns[:artigo_de_evento].should be_new_record
      assigns[:artigo_de_evento].should be_kind_of(ArtigoDeEvento)
    end
  end
end
