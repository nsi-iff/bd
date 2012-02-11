# encoding: utf-8

def popular_area_sub_area
  exatas = Area.create(:nome => 'Ciências Exatas e da Terra')
  SubArea.create(nome: 'Ciência da Computação', area: exatas)

  engenharia = Area.create(:nome => 'Engenharias')
  SubArea.create(nome: 'Engenharia de Produção', area: engenharia)

  biologicas = Area.create(:nome => 'Ciências Biológicas')
  SubArea.create(nome: 'Biologia Geral', area: biologicas)

  agrarias = Area.create(:nome => 'Ciências Agrárias')
  SubArea.create(nome: 'Agronomia', area: agrarias)

  saude = Area.create(:nome => 'Ciências da Saúde')
  SubArea.create(nome: 'Enfermagem', area: saude)

  humanas = Area.create(:nome => 'Ciências Humanas')
  SubArea.create(nome: 'Teologia', area: humanas)

  sociais_aplicadas = Area.create(:nome => 'Ciências Sociais Aplicadas')
  SubArea.create(nome: 'Administração', area: sociais_aplicadas)

  linguisticas = Area.create(:nome => 'Linguística, Letras e Artes')
  SubArea.create(nome: 'Letras', area: linguisticas)

  outras = Area.create(:nome => 'Outras')
  SubArea.create(nome: 'Biomedicina', area: outras)
end

def submeter_conteudo(tipo, opcoes = {})
  popular_area_sub_area
  visit send(:"new_#{tipo}_path")
  fill_in 'Arquivo', with: opcoes[:arquivo] || ''
  fill_in 'Título',
    with: opcoes[:titulo] || 'A Proposal for Ruby Performance Improvements'
  fill_in 'Link', with: opcoes[:link] || 'http://www.rubyconf.org/articles/1'

  select('Ciências Exatas e da Terra', :from => 'Grande Área de Conhecimento')
    
  select('Ciência da Computação', from: 'Área de Conhecimento*')

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
  page.should have_content opcoes[:grande_area_de_conhecimento] || 'Grande Área de Conhecimento: Ciências Exatas e da Terra'
  page.should have_content opcoes[:area_de_conhecimento] || 'Área de Conhecimento: Ciência da Computação'
  unless opcoes[:autores] == false
    page.should have_content opcoes[:nome_autor] || 'Autor: Yukihiro Matsumoto'
    page.should have_content opcoes[:lattes_autor] || 'Curriculum Lattes: http://lattes.cnpq.br/1234567890'
  end
  page.should have_content opcoes[:campus] || 'Campus: Campos Centro'
end
