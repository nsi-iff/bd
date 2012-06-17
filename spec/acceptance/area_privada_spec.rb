# encoding: utf-8

require 'spec_helper'

feature 'Área Privada' do
  before(:each) { Papel.criar_todos }

  scenario 'testar links na área privada' do
    usuario = autenticar_usuario(Papel.all)

    visit area_privada_usuario_path(usuario)
    click_link 'Escrivaninha'
    current_path.should == escrivaninha_usuario_path(usuario)

    visit area_privada_usuario_path(usuario)
    click_link 'Estante'
    current_path.should == estante_usuario_path(usuario)

    visit area_privada_usuario_path(usuario)
    click_link 'Minhas Buscas'
    current_path.should == minhas_buscas_usuario_path(usuario)

    visit area_privada_usuario_path(usuario)
    click_link 'Lista de Revisão'
    current_path.should == lista_de_revisao_usuario_path(usuario)
  end

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
