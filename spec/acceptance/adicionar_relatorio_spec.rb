# encoding: utf-8

require 'spec_helper'

feature 'adicionar relatório' do
  scenario 'padrao' do
    criar_papeis
    autenticar_usuario(Papel.contribuidor)
    submeter_conteudo :relatorio do
      fill_in 'Local da publicação', with: 'Rio de Janeiro'
      fill_in 'Ano', with: '1998'
      fill_in 'Número de páginas', with: '427'
    end

    validar_conteudo
    page.should have_content 'Local da publicação: Rio de Janeiro'
    page.should have_content 'Ano: 1998'
    page.should have_content 'Número de páginas: 427'
  end
end
