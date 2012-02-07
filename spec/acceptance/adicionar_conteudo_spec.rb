# encoding: utf-8

require 'spec_helper'

feature 'adicionar conteudo (referente aos dados básicos)' do
  scenario 'arquivo e link não podem ser fornecidos simultaneamente',
           :driver => :webkit do
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

  scenario 'aceita vários autores', :driver => :webkit do
    submeter_conteudo :artigo_de_evento do
      ['Linus Torvalds',
       'Yukihiro Matsumoto',
       'Guido van Rossum'].each_with_index do |autor, i|
        click_link 'Adicionar autor'
        within "#autores .nested-fields:nth-child(#{i + 1})" do
          fill_in 'Autor', with: autor
          fill_in 'Curriculum Lattes',
            with: "http://lattes.cnpq.br/#{autor.downcase.gsub(' ', '_')}"
        end
      end
    end
    page.should have_content 'Autor: Linus Torvalds'
    page.should have_content 'Curriculum Lattes: http://lattes.cnpq.br/linus_torvalds'
    page.should have_content 'Autor: Yukihiro Matsumoto'
    page.should have_content 'Curriculum Lattes: http://lattes.cnpq.br/yukihiro_matsumoto'
    page.should have_content 'Autor: Guido van Rossum'
    page.should have_content 'Curriculum Lattes: http://lattes.cnpq.br/guido_van_rossum'
  end

  scenario 'campos obrigatórios' do
    submeter_conteudo :artigo_de_evento,
      titulo: '', grande_area_de_conhecimento: '',
      area_de_conhecimento: '', campus: '', autores: false
    [:titulo, :grande_area_de_conhecimento, :area_de_conhecimento,
     :campus].each do |campo|
      within("#artigo_de_evento_#{campo}_input") do
        page.should have_content "can't be blank"
      end
    end
    within('#autores') { page.should have_content "can't be blank" }
  end
end
