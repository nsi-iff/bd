# encoding: utf-8

require 'spec_helper'

feature 'Área Privada' do
  before(:each) { Papel.criar_todos }

  scenario 'apenas gestor pode ver link para lista de revisão' do
    [Papel.membro, Papel.admin, Papel.contribuidor].each do |papel|

      usuario = autenticar_usuario(papel)

      visit area_privada_usuario_path(usuario)
      page.should have_content 'Escrivaninha'
      page.should have_content 'Estante'
      page.should have_content 'Minhas Buscas'
      page.should_not have_content 'Lista de Revisão'
    end

    usuario = autenticar_usuario(Papel.gestor)

    visit area_privada_usuario_path(usuario)
    page.should have_content 'Escrivaninha'
    page.should have_content 'Estante'
    page.should have_content 'Minhas Buscas'
    page.should have_content 'Lista de Revisão'
  end
end
