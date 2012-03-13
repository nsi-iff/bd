# encoding: utf-8

require 'spec_helper'

feature 'aprovar conteúdo' do
  scenario 'gestor deve poder aprovar conteúdo pendente' do
    criar_papeis
    autenticar_usuario(Papel.gestor)
    livro = Factory.create :livro, titulo: 'Foo'
    livro.submeter

    visit aprovacao_path
    page.should have_content 'Foo'

    visit edit_livro_path(livro)
    click_link 'Aprovar'

    visit aprovacao_path
    page.should_not have_content 'Foo'
  end
end
