#encoding: utf-8

require 'spec_helper'

describe "usuarios/area_privada.html.haml" do
  before :each do
    Papel.criar_todos
  end

  %w(contribuidor admin instituicao_admin gestor).each do |papel|
    context "links para usuario #{papel}" do
      before(:each) do
        @usuario = create(:"usuario_#{papel}")
        sign_in :usuario, @usuario
      end

      it 'escrivaninha' do
        render
        rendered.should have_link 'Escrivaninha',
          href: escrivaninha_usuario_path(@usuario)
      end

      it 'estante' do
        render
        rendered.should have_link 'Estante',
          href: estante_usuario_path(@usuario)
      end

      it 'minhas buscas' do
        render
        rendered.should have_link 'Minhas Buscas',
          href: minhas_buscas_usuario_path(@usuario)
      end

      let(:lista_de_revisao) { 'Lista de Revisão' }

      if papel == 'gestor'
        it 'lista de revisão' do
          render
          rendered.should have_link lista_de_revisao,
            href: lista_de_revisao_usuario_path(@usuario)
        end
      else
        it 'não possui lista de revisão' do
          sign_in :usuario, create(:usuario_contribuidor)
          render
          rendered.should_not have_link lista_de_revisao
        end
      end
    end
  end
end
