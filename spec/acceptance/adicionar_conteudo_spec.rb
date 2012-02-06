# encoding: utf-8

require 'spec_helper'

feature 'adicionar conteudo (referente aos dados básicos)' do
  scenario 'arquivo e link não podem ser fornecidos simultaneamente' do
    submeter_conteudo :artigo_de_evento, link: '', arquivo: 'arquivo.nsi'
    page.should have_content 'com sucesso'

    submeter_conteudo :artigo_de_evento, link: 'http://nsi.iff.edu.br',
                                         arquivo: ''
    page.should have_content 'com sucesso'

    submeter_conteudo :artigo_de_evento, link: 'http://nsi.iff.edu.br',
                                         arquivo: 'arquivo.nsi'
    page.should_not have_content 'com sucesso'
    within '#artigo_de_evento_link_input' do
      page.should have_content 'não pode existir simultaneamente a arquivo'
    end
    within '#artigo_de_evento_arquivo_input' do
      page.should have_content 'não pode existir simultaneamente a link'
    end
  end
end
