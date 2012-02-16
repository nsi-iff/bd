# encoding: utf-8

def popular_area_sub_area
  Area.destroy_all
  SubArea.destroy_all
  exatas = Area.create(nome: 'Ciências Exatas e da Terra')
  exatas.sub_areas.create(nome: 'Ciência da Computação')

  engenharia = Area.create(nome: 'Engenharias')
  engenharia.sub_areas.create(nome: 'Engenharia de Produção')

  biologicas = Area.create(nome: 'Ciências Biológicas')
  biologicas.sub_areas.create(nome: 'Biologia Geral')

  agrarias = Area.create(nome: 'Ciências Agrárias')
  agrarias.sub_areas.create(nome: 'Agronomia')

  saude = Area.create(nome: 'Ciências da Saúde')
  saude.sub_areas.create(nome: 'Enfermagem')

  humanas = Area.create(nome: 'Ciências Humanas')
  humanas.sub_areas.create(nome: 'Teologia')

  sociais_aplicadas = Area.create(nome: 'Ciências Sociais Aplicadas')
  sociais_aplicadas.sub_areas.create(nome: 'Administração')

  linguisticas = Area.create(nome: 'Linguística, Letras e Artes')
  linguisticas.sub_areas.create(nome: 'Letras')

  outras = Area.create(nome: 'Outras')
  outras.sub_areas.create(nome: 'Biomedicina')
end

def popular_eixos_tematicos_cursos
  EixoTematico.destroy_all
  Curso.destroy_all
  
  ambiente_saude = EixoTematico.create(nome: 'Ambiente e Saúde')
  ambiente_saude.cursos.create([
    { nome: 'Gestão Ambiental'    },
    { nome: 'Gestão Hospitalar'   },
    { nome: 'Oftálmica'           },
    { nome: 'Radiologia'          },
    { nome: 'Saneamento Ambiental'},
    { nome: 'Sistemas Biomédicos' },
  ])

  apoio_escolar = EixoTematico.create(nome: 'Apoio Escolar')
  apoio_escolar.cursos.create([
    { nome: 'Processos Escolares'},
  ])
end

def popular_graus
  Grau.create nome: 'Graduação'
end

def submeter_conteudo(tipo, opcoes = {})
  popular_area_sub_area
  visit send(:"new_#{tipo}_path")
  fill_in 'Arquivo', with: opcoes[:arquivo] || ''
  fill_in 'Título',
    with: opcoes[:titulo] || 'A Proposal for Ruby Performance Improvements'
  fill_in 'Link', with: opcoes[:link] || 'http://www.rubyconf.org/articles/1'

  select('Ciências Exatas e da Terra', from: 'Grande Área de Conhecimento')

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
