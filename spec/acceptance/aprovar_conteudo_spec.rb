# encoding: utf-8

require 'spec_helper'

feature 'aprovar conteúdo' do
  before(:each) do
    criar_papeis
    popular_area_sub_area
    popular_eixos_tematicos_cursos
  end

  tipos_de_conteudo.each do |tipo|
    scenario "gestor deve poder aprovar #{tipo} pendente" do
      user = autenticar_usuario(Papel.gestor)
      conteudo = Factory.create(tipo)
      conteudo.submeter!

      visit lista_de_revisao_usuario_path(user)
      page.should have_content conteudo.titulo

      visit edit_conteudo_path(conteudo)
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
    visit edit_conteudo_path(artigo)
    click_link 'Aprovar'
    artigo.reload.estado.should == 'granularizando'
    page.driver.post(granularizou_conteudos_path,
                     doc_key: artigo.arquivo.key,
                     grains_keys: {
                       images: 2.times.map {|n| rand.to_s.split('.').last },
                       files: [rand.to_s.split('.').last]
                      })
    artigo.reload.estado.should == 'publicado'
    artigo.should have(2).graos_imagem
    artigo.should have(1).graos_arquivo

    visit conteudo_path(artigo)
  end
end
