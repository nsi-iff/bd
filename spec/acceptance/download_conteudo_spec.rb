# encoding: utf-8

require 'spec_helper'

feature 'baixar conteúdo' do
  scenario 'qualquer usuario pode efetuar o download do conteúdo publicado' do
    submeter_conteudo :artigo_de_evento, link: '',
      arquivo: File.join(Rails.root, *%w(spec resources arquivo.doc))
    visit destroy_usuario_session_path
    artigo = ArtigoDeEvento.last
    artigo.submeter!
    artigo.aprovar!
    visit conteudo_path(artigo)
    click_button 'Download'
    baixado = "#{Rails.root}/tmp/#{artigo.titulo}.#{artigo.extensao}"
    postado = "#{Rails.root}/spec/resources/arquivo.doc"
    FileUtils.compare_file(baixado, postado).should == true
    File.delete(baixado)
  end
end

