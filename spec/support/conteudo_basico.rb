# encoding: utf-8

def submeter_conteudo(tipo, opcoes = {})
  visit send(:"new_#{tipo}_path")
  fill_in 'Arquivo', with: opcoes[:arquivo] || ''
  fill_in 'Título',
    with: opcoes[:titulo] || 'A Proposal for Ruby Performance Improvements'
  fill_in 'Link', with: opcoes[:link] || 'http://www.rubyconf.org/articles/1'
  fill_in 'Grande Área de Conhecimento',
    with: opcoes[:grande_area_de_conhecimento] || 'Ciência da Computação'
  fill_in 'Área de Conhecimento*',
    with: opcoes[:area_de_conhecimento] || 'Linguagens de Programação'
  unless opcoes[:autores] == false
    click_link 'Adicionar autor'
    fill_in 'Autor', with: opcoes[:nome_autor] || 'Yukihiro Matsumoto'
    fill_in 'Curriculum Lattes',
      with: opcoes[:lattes_autor] || 'http://lattes.cnpq.br/1234567890'
  end
  fill_in 'Campus da Instituição do Usuário',
    with: opcoes[:campus] || 'Campos Centro'
  yield if block_given?
  click_button 'Salvar'
end

def validar_conteudo(opcoes = {})
  page.should have_content opcoes[:titulo] || 'Título: A Proposal for Ruby Performance Improvements'
  (page.should have_content opcoes[:link] || 'http://www.rubyconf.org/articles/1') unless opcoes[:arquivo]
  page.should have_content opcoes[:arquivo] || ''
  page.should have_content opcoes[:grande_area_de_conhecimento] || 'Grande Área de Conhecimento: Ciência da Computação'
  page.should have_content opcoes[:area_de_conhecimento] || 'Área de Conhecimento: Linguagens de Programação'
  unless opcoes[:autores] == false
    page.should have_content opcoes[:nome_autor] || 'Autor: Yukihiro Matsumoto'
    page.should have_content opcoes[:lattes_autor] || 'Curriculum Lattes: http://lattes.cnpq.br/1234567890'
  end
  page.should have_content opcoes[:campus] || 'Campus: Campos Centro'
end
