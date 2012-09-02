# encoding: utf-8

require 'spec_helper'

feature 'Thumbnail do documento' do
  scenario 'deve aparecer na view do conteudo' do
    Papel.criar_todos
    autenticar_usuario(Papel.contribuidor)
    submeter_conteudo :artigo_de_evento, link: '',
      arquivo: File.join(Rails.root, *%w(spec resources manual.odt))
    artigo = ArtigoDeEvento.last
    artigo.submeter!

    usuario = autenticar_usuario(Papel.gestor)
    artigo.campus_id = usuario.campus_id
    visit conteudo_path(artigo)
    artigo.aprovar!

    thumb_base64 = File.open("#{Rails.root}/spec/resources/thumb_do_manual_base64.txt").read
    response = ServiceRegistry.sam.store file: thumb_base64

    artigo.granularizou!(graos: {}, thumbnail: response.key)
    artigo.reload.estado.should == 'publicado'

    visit conteudo_path(artigo)
    page.find("img[src*='data:image/png;base64,#{thumb_base64}']")
  end
end


