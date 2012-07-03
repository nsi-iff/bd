# encoding: utf-8

require 'spec_helper'

feature 'baixar conteúdo' do
  context 'não publicado' do
    scenario 'não deve existir o link de download para conteúdo não publicado' do
      submeter_conteudo :artigo_de_evento, link: '',
        arquivo: File.join(Rails.root, *%w(spec resources manual.odt))
      artigo = ArtigoDeEvento.last
      artigo.submeter!
      visit conteudo_path(artigo)
      page.should_not have_link 'Download'
    end
  end
  context 'conteúdo publicado' do
    scenario 'qualquer usuario pode efetuar o download do conteúdo publicado' do
      submeter_conteudo :artigo_de_evento, link: '',
        arquivo: File.join(Rails.root, *%w(spec resources arquivo.doc))
      artigo = ArtigoDeEvento.last
      artigo.submeter!
      artigo.aprovar!
      visit conteudo_path(artigo)
      click_link 'Download'
      baixado = "#{Rails.root}/tmp/#{artigo.titulo}.odt"
      postado = "#{Rails.root}/spec/resources/arquivo.doc"
      FileUtils.compare_file(baixado, postado).should == true
    end
  end
end

