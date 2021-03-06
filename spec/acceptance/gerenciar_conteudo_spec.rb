# encoding: utf-8

require 'spec_helper'

feature 'adicionar conteudo (referente aos dados básicos)' do
  scenario 'adicionar dados basicos de conteudo' do
    popular_area_sub_area
    Papel.criar_todos
    usuario = autenticar_usuario(Papel.contribuidor)
    visit new_conteudo_path(tipo: :artigo_de_evento)
    fill_in 'Título', with: 'A Proposal for Ruby Performance Improvements'
    fill_in 'Link', with: 'http://www.rubyconf.org/articles/1'
    select('Ciências Exatas e da Terra', from: 'Grande Área de Conhecimento')
    select('Ciência da Computação', from: 'Área de Conhecimento')
    select(usuario.campus.nome, from: 'Campus da Instituição do Autor')
    click_link 'Adicionar outro autor'
    fill_in 'Autor', with: 'Yukihiro Matsumoto'
    fill_in 'Curriculum Lattes', with: 'http://lattes.cnpq.br/1234567890'
    fill_in 'Direitos', with: 'Direitos e esquerdos'
    fill_in 'Resumo', with: 'This work proposes an Ruby performance improvement'
    page.should have_selector('a[href="http://buscatextual.cnpq.br/buscatextual/busca.do?metodo=apresentar"]')
    click_button 'Salvar'

    page.should have_content 'A Proposal for Ruby Performance Improvements'
    page.should have_content 'http://www.rubyconf.org/articles/1'
    page.should have_content 'Ciências Exatas e da Terra'
    page.should have_content 'Ciência da Computação'
    page.should have_content 'Yukihiro Matsumoto'
    page.should have_content 'http://lattes.cnpq.br/1234567890'
    page.should have_content "#{usuario.campus.nome}"
    page.should have_content 'Direitos e esquerdos'
    page.should have_content 'This work proposes an Ruby performance improvement'
  end

  scenario 'arquivo e link não podem ser fornecidos simultaneamente' do
    submeter_conteudo :livro, link: '', arquivo: Rails.root + 'spec/resources/arquivo.pdf'
    page.should have_content 'com sucesso'

    submeter_conteudo :livro, link: 'http://nsi.iff.edu.br',
                                         arquivo: ''
    page.should have_content 'com sucesso'

    submeter_conteudo :livro, link: 'http://nsi.iff.edu.br',
                                         arquivo: Rails.root + 'spec/resources/arquivo.pdf'

    page.should_not have_content 'com sucesso'
    within '#livro_link_input' do
      page.should have_content 'não pode existir simultaneamente a arquivo'
    end
    within '#arquivo' do
      page.should have_content 'não pode existir simultaneamente a link'
    end
  end

  scenario 'campos obrigatórios' do
    submeter_conteudo :artigo_de_evento,
      titulo: '', autores: false
    click_button 'Submeter'
    [:titulo].each do |campo|
      within("#artigo_de_evento_#{campo}_input") do
        page.should have_content "não pode ficar em branco"
      end
    end
    within('#autores') { page.should have_content "não pode ficar em branco" }
  end
end
