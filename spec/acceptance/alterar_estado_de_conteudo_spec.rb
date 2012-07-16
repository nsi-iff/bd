# encoding: utf-8

require 'spec_helper'

feature 'devolver conteúdo' do
  before(:each) { Papel.criar_todos }
  
  scenario 'Alterar estado de um conteúdo de "Publicado" para "Pendente"' do
    gestor = autenticar_usuario(Papel.gestor)
    conteudo = create(:livro)
    conteudo.campus_id = gestor.campus_id
    conteudo.submeter! && conteudo.aprovar!

    conteudo.estado.should == 'publicado'

    visit conteudo_path(conteudo)
    click_button 'Retornar para revisão'

    conteudo.reload.estado.should == 'pendente'
  end
    
  scenario 'recolhido' do
    gestor = autenticar_usuario(Papel.gestor)
    livro = create(:livro_recolhido, campus: gestor.campus)
    visit conteudo_path(livro)
    click_button 'Retornar para revisão'
    livro.reload.should be_pendente
  end
end
