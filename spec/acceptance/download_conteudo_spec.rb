# encoding: utf-8
require 'spec_helper'

feature 'baixar conteúdo' do
  scenario 'qualquer usuario pode efetuar o download do conteúdo publicado' do
    submeter_conteudo :artigo_de_evento, link: '',
      arquivo: File.join(Rails.root, *%w(spec resources arquivo.doc))
    visit destroy_usuario_session_path
    artigo = ArtigoDeEvento.last
    artigo.stub(:granularizavel?).and_return(false)
    artigo.submeter!
    artigo.aprovar!
    visit conteudo_path(artigo)
    link = find("#download").find('a')
    link["href"].should == artigo.link_download
  end
end

