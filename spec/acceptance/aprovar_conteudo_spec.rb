# encoding: utf-8

require 'spec_helper'

feature 'aprovar conteúdo' do
  before(:each) do
    Papel.criar_todos
    popular_area_sub_area
    popular_eixos_tematicos_cursos
  end

  tipos_de_conteudo.each do |tipo|
    scenario "gestor deve poder aprovar #{tipo} pendente" do
      user = autenticar_usuario(Papel.gestor)
      conteudo = create(tipo)
      conteudo.campus_id = user.campus_id
      conteudo.submeter!

      visit lista_de_revisao_usuario_path(user)
      page.should have_content conteudo.titulo

      visit conteudo_path(conteudo)
      click_button 'Aprovar'

      visit lista_de_revisao_usuario_path(user)
      page.should_not have_content conteudo.titulo
    end
  end

  scenario 'envia conteúdo para granularização ao aprovar' do
    autenticar_usuario(Papel.contribuidor)
    submeter_conteudo :artigo_de_evento, link: '',
      arquivo: File.join(Rails.root, *%w(spec resources manual.odt))
    artigo = ArtigoDeEvento.last
    artigo.submeter!

    usuario = autenticar_usuario(Papel.gestor)
    artigo.campus_id = usuario.campus_id
    visit conteudo_path(artigo)
    artigo.aprovar!
    artigo.reload.estado.should == 'granularizando'
    page.driver.post(granularizou_conteudos_path,
                     doc_key: artigo.arquivo.key,
                     grains_keys: {
                       images: 2.times.map {|n| rand.to_s.split('.').last },
                       files: [rand.to_s.split('.').last]
                      },
                      thumbnail_key: 'a dummy key')
    artigo.reload.estado.should == 'publicado'
    artigo.should have(2).graos_imagem
    artigo.should have(1).graos_arquivo
    artigo.arquivo.thumbnail_key.should == 'a dummy key'
  end

  scenario 'gestor de instituição não pode aprovar conteudo de outra instituição' do
    Papel.criar_todos
    ins1 = Instituicao.create(nome: 'instituicao1')
    camp1 = ins1.campus.create(nome: 'campus1')
    ins2 = Instituicao.create(nome: 'instituicao2')
    camp2 = ins2.campus.create(nome: 'campus2')
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
