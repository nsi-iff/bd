#encoding: utf-8

require 'spec_helper'

describe "usuarios/area_privada.html.haml" do
  before :each do
    Papel.criar_todos
    @usuario = create(:usuario_gestor)
    sign_in :usuario, @usuario
  end

  context 'contem link para' do
    before(:each) { render }

    it 'escrivaninha' do
      rendered.should have_link 'Escrivaninha',
        href: escrivaninha_usuario_path(@usuario)
    end

    it 'estante' do
      rendered.should have_link 'Estante',
        href: estante_usuario_path(@usuario)
    end

    it 'minhas buscas' do
      rendered.should have_link 'Minhas Buscas',
        href: minhas_buscas_usuario_path(@usuario)
    end

    it 'lista de revisão' do
      rendered.should have_link 'Lista de Revisão',
        href: lista_de_revisao_usuario_path(@usuario)
    end
  end
end
