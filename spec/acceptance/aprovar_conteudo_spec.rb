# encoding: utf-8

require 'spec_helper'

feature 'aprovar conteúdo' do
  before(:each) do
    Papel.criar_todos
    popular_area_sub_area
    popular_eixos_tematicos_cursos
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
                      })
    artigo.reload.estado.should == 'publicado'
    artigo.should have(2).graos_imagem
    artigo.should have(1).graos_arquivo
  end
end
