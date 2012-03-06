# encoding: utf-8

require 'spec_helper'

feature 'Escrivaninha' do
  scenario 'mostra os conteúdos do usuário em estado de edição' do
    criar_papeis
    usuario = autenticar_usuario(Papel.contribuidor)
    outro = Factory.create(:usuario_contribuidor)
    c1 = Factory.create(:artigo_de_evento, titulo: 'Ruby is cool!', contribuidor: usuario)
    c2 = Factory.create(:livro, titulo: 'Agile rulz!', contribuidor: usuario)
    c3 = Factory.create(:relatorio, titulo: 'We love Ruby and Agile!', contribuidor: outro)

    visit area_privada_usuario_path(usuario)
    click_link 'Escrivaninha' # find(:xpath, "//a/img[@title='Escrivaninha']").click
    page.should have_content 'Ruby is cool'
    page.should have_content 'Agile rulz'
    page.should_not have_content 'We love Ruby and Agile'

    c2.submeter!
    visit escrivaninha_usuario_path(usuario)
    page.should have_content 'Ruby is cool'
    page.should_not have_content 'Agile rulz'
    page.should_not have_content 'We love Ruby and Agile'
  end

  scenario 'somente pode ser acessada pelo próprio usuário' do
    criar_papeis
    usuario = Factory.create(:usuario_contribuidor)
    outro = autenticar_usuario(Papel.contribuidor)
    visit area_privada_usuario_path(usuario)
    page.should have_content acesso_negado
    visit escrivaninha_usuario_path(usuario)
    page.should have_content acesso_negado
  end
end
