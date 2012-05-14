# encoding: utf-8

def popular_area_sub_area
  unless Area.find_by_nome('Ciências Exatas e da Terra')
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
end

def popular_eixos_tematicos_cursos
  unless EixoTematico.find_by_nome('Ambiente e Saúde')
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

    militar = EixoTematico.create(nome: 'Militar')
    militar.cursos.create([
      { nome: 'Comunicações Aeronáuticas'      },
      { nome: 'Fotointeligência'               },
      { nome: 'Gerenciamento de Tráfego Aéreo' },
      { nome: 'Gestão e Manutenção Aeronáutica'},
      { nome: 'Meteorologia Aeronáutica'       },
      { nome: 'Sistemas de Armas'              }
    ])
  end
end

def popular_instituicao_campus(usuario = nil)
  unless Instituicao.find_by_nome('Instituto Federal de Educação, Ciência e Tecnologia Fluminense')
    iffluminense = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia Fluminense')
    iffluminense.campus.create([
      { nome: 'Campus Bom Jesus de Itabapoana' },
      { nome: 'Campus Cabo Frio'               },
      { nome: 'Campus Campos Centro'           },
      { nome: 'Campus Campos Guarus'           },
      { nome: 'Campus Itaperuna'               },
      { nome: 'Campus Macaé'                   }
    ])

    ifamapa = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Amapá')
    ifamapa.campus.create([
      { nome: 'Campus Macapá' }
    ])
  end

  if usuario
    usuario.campus = Campus.find_by_nome('Campus Campos Centro')
    usuario.save!
  end
end

def popular_graus
  Grau.criar_todos if Grau.count == 0
end

def submeter_conteudo(tipo, opcoes = {})
  popular_area_sub_area
  criar_papeis
  usuario = autenticar_usuario(Papel.contribuidor)
  popular_instituicao_campus(usuario)
  visit new_conteudo_path(tipo: tipo)
  preencher_campos tipo, opcoes

  yield if block_given?
  click_button 'Salvar'
end

def preencher_campos(tipo, opcoes = {})
  fill_in 'Título',
    with: opcoes[:titulo] || 'A Proposal for Ruby Performance Improvements'

  attach_file('Arquivo', opcoes[:arquivo]) if opcoes[:arquivo].present?

  fill_in 'Link', with: opcoes[:link] || 'http://www.rubyconf.org/articles/1'

  select("Ciências Exatas e da Terra", from: 'area')

  select('Ciência da Computação', from: "#{tipo}_sub_area_id")

  select 'Campus Campos Centro', from: 'Campus da Instituição do Usuário'

  unless opcoes[:autores] == false
    click_link 'Adicionar autor'
    fill_in 'Autor', with: opcoes[:nome_autor] || 'Yukihiro Matsumoto'
    fill_in 'Curriculum Lattes',
      with: opcoes[:lattes_autor] || 'http://lattes.cnpq.br/1234567890'
  end
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
end

def tipos_de_conteudo
  [:livro, :artigo_de_evento, :artigo_de_periodico, :objeto_de_aprendizagem,
   :periodico_tecnico_cientifico, :relatorio, :trabalho_de_obtencao_de_grau]
end
