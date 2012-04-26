# encoding: utf-8

require 'spec_helper'

feature 'sessão e registro de usuário' do

  before(:each) do
    criar_papeis
  end

  scenario 'modificar opções de campus ao modificar instituição', :js => true do
    popular_instituicao_campus
    visit root_path
    click_link 'Registrar Usuário'
    select 'Instituto Federal de Educação, Ciência e Tecnologia do Amapá', from: 'select_instituicao'
    save_and_open_page
    select 'Campus Macapá', from: 'Campus'
    select 'Instituto Federal de Educação, Ciência e Tecnologia Fluminense', from: 'select_instituicao'
    select 'Campus Macaé', from: 'Campus'
    select 'Campus Campos Centro', from: 'Campus'
  end

  scenario 'cadastrar usuario' do
    popular_instituicao_campus
    visit root_path
    click_link 'Registrar Usuário'
    fill_in 'Nome Completo', with: 'Foo Bar'
    fill_in 'E-mail', with: 'foo@bar.com'
    fill_in 'Senha', with: 'foobar'
    fill_in 'Confirmação de Senha', with: 'foobar'
    select 'Instituto Federal de Educação, Ciência e Tecnologia Fluminense', from: 'select_instituicao'
    select 'Campus Campos Centro', from: 'Campus'
    click_button 'Registrar'

    page.should have_content 'Login efetuado com sucesso'
  end

  scenario 'acessar sistema' do
    usuario = Factory.create :usuario, password: 'foobar', password_confirmation: 'foobar'

    visit root_path
    click_link 'Acessar'
    fill_in 'E-mail', with: usuario.email
    fill_in 'Senha', with: 'foobar'
    click_button 'Entrar'

    page.should have_content 'Login efetuado com sucesso'
  end

  scenario 'sair do sistema' do
    autenticar_usuario

    click_link 'Sair'

    page.should have_content 'Logout efetuado com sucesso'
  end
end
