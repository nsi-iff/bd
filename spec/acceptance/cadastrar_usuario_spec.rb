# encoding: utf-8

require 'spec_helper'

feature 'cadastrar usuário na BD' do
  scenario 'cadastrar usuários preenchendo todos os campos' do
    visit new_usuario_registration_path
    within_fieldset 'Registro de Usuário' do
      fill_in 'Usuário', with: 'darthvader'
      fill_in 'Nome completo', with: 'Anaquin Skywalker'
      fill_in 'E-mail', with: 'vader@darkside.com'
      fill_in 'Senha', with: 'deathstar'
      fill_in 'Confirmação de senha', with: 'deathstar'
      fill_in 'Instituição', with: 'Star Wars'
      fill_in 'Campus', with: 'Death Star'
    end
    click_button 'Registrar'

    page.should have_content 'Login efetuado com sucesso'
  end
end
