# encoding: utf-8

require 'spec_helper'

feature 'apresentar breadcrumbs para' do
  before(:each) do
    Papel.criar_todos
    @usuario = autenticar_usuario(Papel.all)
  end

  context 'usuários' do
    let(:crumb_usuarios) { 'Usuários » ' }

    scenario 'index' do
      verificar_breadcrumbs usuarios_path, 'Usuários'
    end

    scenario 'busca por nome' do
      verificar_breadcrumbs(
        buscar_por_nome_usuarios_path, crumb_usuarios + 'Busca por nome')
    end

    scenario 'papéis' do
      verificar_breadcrumbs(
        papeis_usuarios_path, crumb_usuarios + 'Papéis')
    end

    scenario 'área privada' do
      verificar_breadcrumbs(
        area_privada_usuario_path(@usuario), crumb_usuarios + 'Área privada')
    end

    scenario 'minhas buscas' do
      verificar_breadcrumbs(
        minhas_buscas_usuario_path(@usuario), crumb_usuarios + 'Minhas buscas')
    end
  end

  context 'ajuda' do
    let(:crumb_ajuda) { 'Ajuda » ' }

    scenario 'ajuda' do
      verificar_breadcrumbs('/ajuda', 'Ajuda')
    end

    scenario 'manuais' do
      verificar_breadcrumbs('/ajuda/manuais', crumb_ajuda + 'Manuais')
    end
  end

  context 'páginas' do
    let(:crumb_paginas) { 'Início » ' }

    scenario 'home' do
      verificar_breadcrumbs root_path, 'Início'
    end

    scenario 'sobre' do
      verificar_breadcrumbs '/sobre', crumb_paginas + 'Sobre'
    end

    scenario 'noticias' do
      verificar_breadcrumbs '/noticias', crumb_paginas + 'Notícias'
    end

    scenario 'adicionar conteúdo' do
      verificar_breadcrumbs '/adicionar_conteudo', crumb_paginas + 'Adicionar conteúdo'
    end

    scenario 'estatísticas' do
      verificar_breadcrumbs '/estatisticas', crumb_paginas + 'Estatísticas'
    end

    scenario 'docmentos mais acessados' do
      verificar_breadcrumbs '/documentos_mais_acessados', crumb_paginas + 'Documentos mais acessados'
    end

    scenario 'gráficos de acessos' do
      verificar_breadcrumbs '/graficos_de_acessos', crumb_paginas + 'Gráficos'
    end
  end
end
