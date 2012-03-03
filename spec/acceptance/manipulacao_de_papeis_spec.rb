# encoding: utf-8

require 'spec_helper'

feature 'mudar papel do usuário' do
  scenario 'adicionando papel de membro e administrador para usuário' do
    criar_papeis
    autenticar_usuario
    visit '/usuarios'
    check 'foo@bar.com["membro"]'
    check 'foo@bar.com["gestor"]'
    click_button 'Salvar'

    page.has_checked_field? 'foo@bar.com["membro"]'
    page.has_checked_field? 'foo@bar.com["gestor"]'
  end
end

