# encoding: utf-8

require 'spec_helper'

feature 'aprovar conteúdo' do
  before(:each) do
    Papel.criar_todos
  end

  scenario 'envia conteúdo para granularização ao aprovar' do
    usuario = autenticar_usuario(Papel.gestor)
    artigo = create(:artigo_de_evento_pendente,
      arquivo_para_conteudo(:odt).merge(campus: usuario.campus))
    visit conteudo_path(artigo)
    click_button 'Aprovar'
    artigo.reload.should be_granularizando
    page.driver.post(granularizou_conteudos_path,
                     doc_key: artigo.arquivo.key,
                     grains_keys: {
                       images: 2.times.map {|n| rand.to_s.split('.').last },
                       files: [rand.to_s.split('.').last]
                      },
                      thumbnail_key: 'a dummy key')
    artigo.reload.should be_publicado
    artigo.should have(2).graos_imagem
    artigo.should have(1).graos_arquivo
    artigo.arquivo.thumbnail_key.should == 'a dummy key'
  end

  scenario 'cria uma notificação para o usuário e conteúdo ao aprovar' do
    usuario = autenticar_usuario(Papel.gestor)
    livro = create(:livro, contribuidor_id: usuario.id)
    livro.submeter! && livro.aprovar!
    livro.estado.should == 'publicado'
    usuario.notificacoes.should_not == []
    livro.notificacoes.should_not == []
  end
end
