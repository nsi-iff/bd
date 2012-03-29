# encoding: utf-8

require 'spec_helper'

feature 'acessar sistema' do
  scenario 'cadastrar usuario' do
    visit root_path
    click_link 'Registrar Usuário'
    fill_in 'Nome Completo', with: 'Foo Bar'
    fill_in 'E-mail', with: 'foo@bar.com'
    fill_in 'Senha', with: 'foobar'
    fill_in 'Confirmação de Senha', with: 'foobar'
    fill_in 'Instituição', with: 'instituicao'
    fill_in 'Campus', with: 'campus'
    click_button 'Registrar'

    page.should have_content 'Login efetuado com sucesso'
  end
end
