# encoding: utf-8
require 'spec_helper'

feature 'baixar conteúdo' do
  scenario 'qualquer usuario pode efetuar o download do conteúdo publicado' do
    submeter_conteudo :livro, link: '',
      arquivo: File.join(Rails.root, *%w(spec resources arquivo.doc))
    visit destroy_usuario_session_path
    livro = Livro.last
    livro.stub(:granularizavel?).and_return(false)
    livro.submeter!
    livro.aprovar!
    visit conteudo_path(livro)
    click_link 'Download'
  end
end