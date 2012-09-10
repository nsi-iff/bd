# encoding: utf-8

require 'spec_helper'

feature 'Thumbnail do documento' do
  scenario 'deve aparecer na view do conteudo' do
    Papel.criar_todos
    artigo = create(:artigo_de_evento)
    artigo.stub(:granularizavel?).and_return(true)
    artigo.link = ''
    artigo.arquivo = create(:arquivo)
    aprovar(artigo)

    thumb_base64 = File.open("#{Rails.root}/spec/resources/thumb_do_manual_base64.txt").read
    response = ServiceRegistry.sam.store file: thumb_base64

    artigo.granularizou!(graos: {}, thumbnail: response.key)
    artigo.reload.estado.should == 'publicado'

    visit conteudo_path(artigo)
    page.find("img[src*='data:image/png;base64,#{thumb_base64}']")
  end
end
