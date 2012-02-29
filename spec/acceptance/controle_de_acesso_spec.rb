# encoding: utf-8

require 'spec_helper'

feature 'controle de acesso' do
  context 'adicionar conteudos' do
    scenario 'pode ser acessado por gestores e contribuidores de conteúdo' do
      Papel.criar_todos
      popular_area_sub_area
      [Papel.gestor, Papel.contribuidor].each do |papel|
        autenticar_usuario(papel)
        visit new_artigo_de_evento_path
        page.should_not have_content acesso_negado
      end

      [Papel.admin, Papel.membro].each do |papel|
        autenticar_usuario(papel)
        visit new_artigo_de_evento_path
        page.should have_content acesso_negado
      end
    end
  end
end

