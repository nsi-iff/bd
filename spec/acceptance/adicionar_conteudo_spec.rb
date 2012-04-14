# encoding: utf-8

require 'spec_helper'

feature 'adicionar conteudo (referente aos dados básicos)' do
  scenario 'adicionar dados basicos de conteudo', javascript: true do
    popular_area_sub_area
    criar_papeis
    usuario = autenticar_usuario(Papel.contribuidor)
    visit new_conteudo_path(tipo: :artigo_de_evento)
    fill_in 'Título', with: 'A Proposal for Ruby Performance Improvements'
    fill_in 'Link', with: 'http://www.rubyconf.org/articles/1'
    select('Ciências Exatas e da Terra', from: 'Grande Área de Conhecimento')
    select('Ciência da Computação', from: 'Área de Conhecimento*')
    select(usuario.campus.nome, from: 'Campus da Instituição do Usuário')
    click_link 'Adicionar autor'
    fill_in 'Autor', with: 'Yukihiro Matsumoto'
    fill_in 'Curriculum Lattes', with: 'http://lattes.cnpq.br/1234567890'
    fill_in 'Direitos', with: 'Direitos e esquerdos'
    fill_in 'Resumo', with: 'This work proposes an Ruby performance improvement'
    click_button 'Salvar'

    page.should have_content 'Título: A Proposal for Ruby Performance Improvements'
    page.should have_content 'Link: http://www.rubyconf.org/articles/1'
    page.should have_content 'Grande Área de Conhecimento: Ciências Exatas e da Terra'
    page.should have_content 'Área de Conhecimento: Ciência da Computação'
    page.should have_content 'Autor: Yukihiro Matsumoto'
    page.should have_content 'Curriculum Lattes: http://lattes.cnpq.br/1234567890'
    page.should have_content "Campus: #{usuario.campus.nome}"
    page.should have_content 'Direitos: Direitos e esquerdos'
    page.should have_content 'Resumo: This work proposes an Ruby performance improvement'
    page.should have_content "Contribuidor: #{usuario.nome_completo}"
  end

  scenario 'arquivo e link não podem ser fornecidos simultaneamente' do
    submeter_conteudo :artigo_de_evento, link: '', arquivo: Rails.root + 'spec/resources/arquivo.pdf'
    page.should have_content 'com sucesso'

    submeter_conteudo :artigo_de_evento, link: 'http://nsi.iff.edu.br',
                                         arquivo: ''
    page.should have_content 'com sucesso'

    submeter_conteudo :artigo_de_evento, link: 'http://nsi.iff.edu.br',
                                         arquivo: Rails.root + 'spec/resources/arquivo.pdf'
    page.should_not have_content 'com sucesso'
    within '#artigo_de_evento_link_input' do
      page.should have_content 'não pode existir simultaneamente a arquivo'
    end
    within '#artigo_de_evento_arquivo_input' do
      page.should have_content 'não pode existir simultaneamente a link'
    end
  end

  scenario 'aceita vários autores', javascript: true do
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
      titulo: '', autores: false
    [:titulo].each do |campo|
      within("#artigo_de_evento_#{campo}_input") do
        page.should have_content "não pode ficar em branco"
      end
    end
    within('#autores') { page.should have_content "não pode ficar em branco" }
  end

  scenario "conteudo da área deve mudar quando grande área é selecionada", javascript: true do
    popular_area_sub_area
    criar_papeis
    autenticar_usuario(Papel.contribuidor)
    visit new_conteudo_path(tipo: :artigo_de_evento)

    select('Ciências Exatas e da Terra', from: 'Grande Área de Conhecimento')
    select('Ciência da Computação', from: 'Área de Conhecimento*')

    select('Engenharias', from: 'Grande Área de Conhecimento')
    select('Engenharia de Produção', from: 'Área de Conhecimento*')

    select('Ciências Biológicas', from: 'Grande Área de Conhecimento')
    select('Biologia Geral', from: 'Área de Conhecimento*')

    select('Ciências da Saúde', from: 'Grande Área de Conhecimento')
    select('Enfermagem', from: 'Área de Conhecimento*')

    select('Ciências Agrárias', from: 'Grande Área de Conhecimento')
    select('Agronomia', from: 'Área de Conhecimento*')

    select('Ciências Sociais Aplicadas', from: 'Grande Área de Conhecimento')
    select('Administração', from: 'Área de Conhecimento*')

    select('Ciências Humanas', from: 'Grande Área de Conhecimento')
    select('Teologia', from: 'Área de Conhecimento*')

    select('Linguística, Letras e Artes', from: 'Grande Área de Conhecimento')
    select('Letras', from: 'Área de Conhecimento*')

    select('Outras', from: 'Grande Área de Conhecimento')
    select('Biomedicina', from: 'Área de Conhecimento*')
  end
end
