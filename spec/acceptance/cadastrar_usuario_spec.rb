# encoding: utf-8

require 'spec_helper'

feature 'mudar papel do usuário' do
  scenario 'adicionando papel de membro e administrador para usuário' do
    criar_papeis
    autenticar_usuario
    visit '/usuarios/edit'
    within_fieldset 'Editar Usuario' do
     fill_in 'Senha atual', with: 'foobar'
     within_fieldset 'Papeis do usuário' do
       check 'membro'
       check 'administrador'
     end
    end

    click_button 'Atualizar'

    page.should have_content 'A sua conta foi atualizada com sucesso.'
    visit '/usuarios/edit'

    page.has_checked_field? 'membro'
    page.has_checked_field? 'administrador'
  end
end
