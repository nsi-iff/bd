# encoding: utf-8

require 'spec_helper'

feature 'aprovar conteúdo' do
  before(:each) do
    criar_papeis
    popular_area_sub_area
    popular_eixos_tematicos_cursos
  end

  [:livro, :artigo_de_evento, :artigo_de_periodico, :objeto_de_aprendizagem,
   :periodico_tecnico_cientifico, :relatorio, :trabalho_de_obtencao_de_grau].
   each do |tipo|
    scenario "gestor deve poder aprovar #{tipo} pendente" do
      user = autenticar_usuario(Papel.gestor)
      conteudo = Factory.create(tipo)
      conteudo.submeter!

      visit lista_de_revisao_usuario_path(user)
      page.should have_content conteudo.titulo

      visit send("edit_#{tipo}_path", conteudo)
      click_link 'Aprovar'

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

    autenticar_usuario(Papel.gestor)
    visit edit_artigo_de_evento_path(artigo)
    click_link 'Aprovar'
    if integracao?
      artigo.reload.estado.should == 'granularizando'
      sleep(5)
    else
      page.driver.post(granularizou_artigos_de_evento_path,
                       doc_key: artigo.arquivo.key,
                       grains_keys: {
                         images: 2.times.map {|n| rand.to_s.split('.').last },
                         files: [rand.to_s.split('.').last]
                        })
    end
    artigo.reload.estado.should == 'publicado'
    artigo.should have(2).graos_imagem
    artigo.should have(1).graos_arquivo

    visit artigo_de_evento_path(artigo)
    page.should have_content '3 grãos'
  end
end

