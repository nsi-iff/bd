# encoding: utf-8

require 'spec_helper'

feature 'retornar conteúdo para revisão' do
  before(:each) { Papel.criar_todos }

  scenario 'publicado' do
    gestor = autenticar_usuario(Papel.gestor)
    conteudo = create(:livro_publicado, campus: gestor.campus)
    conteudo.should be_publicado
    visit conteudo_path(conteudo)
    click_button 'Retornar para revisão'
    conteudo.reload.should be_pendente
  end

  scenario 'recolhido' do
    gestor = autenticar_usuario(Papel.gestor)
    livro = create(:livro_recolhido, campus: gestor.campus)
    visit conteudo_path(livro)
    click_button 'Retornar para revisão'
    livro.reload.should be_pendente
  end
end
