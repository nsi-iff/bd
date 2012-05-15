# encoding: utf-8

require 'spec_helper'

feature 'mudar papel do usuário' do
  scenario 'usuário não admin, não pode acessar página de manipulação de papéis' do
    criar_papeis
    autenticar_usuario(Papel.gestor)
    livro = FactoryGirl.create(:livro, titulo: 'programming')
    livro.submeter

    visit conteudos_pendentes_path

    page.should have_content 'programming'
  end
end
