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
    artigo.aprovar!
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

  scenario 'gestor de instituição não pode aprovar conteudo de outra instituição' do
    Papel.criar_todos
    ins1 = Instituicao.create(nome: 'instituicao1')
    camp1 = ins1.campi.create(nome: 'campus1')
    ins2 = Instituicao.create(nome: 'instituicao2')
    camp2 = ins2.campi.create(nome: 'campus2')
    gestor = create(:usuario_gestor, campus: camp1)

    conteudo = create(:relatorio)
    conteudo.campus_id= camp2.id
    conteudo.submeter!

    autenticar(gestor)

    visit conteudo_path(conteudo)
    conteudo.aprovar
    page.should_not have_button 'Aprovar'
  end
end
