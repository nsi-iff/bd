# encoding: utf-8

require 'spec_helper'

feature 'apresentar breadcrumbs para' do
  before(:each) do
    Papel.criar_todos
    @usuario = autenticar_usuario(Papel.all)
  end

  let(:crumb_default) { "Você está aqui: Início #{breadcrumb_separator} " }

  context 'usuários' do
    let(:crumb_usuarios) { "Usuários #{breadcrumb_separator} " }

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
  end

  context 'ajuda' do
    let(:crumb_ajuda) { "Ajuda #{breadcrumb_separator} " }

    scenario 'ajuda' do
      verificar_breadcrumbs('/ajuda', 'Ajuda')
    end

    scenario 'manuais' do
      verificar_breadcrumbs('/ajuda/manuais', crumb_ajuda + 'Manuais')
    end
  end

  context 'páginas' do
    scenario 'home' do
      verificar_breadcrumbs root_path, 'Início'
    end

    scenario 'sobre' do
      verificar_breadcrumbs '/sobre', crumb_default + 'Sobre'
    end

    scenario 'noticias' do
      verificar_breadcrumbs '/noticias', crumb_default + 'Notícias'
    end

    scenario 'adicionar conteúdo' do
      verificar_breadcrumbs '/adicionar_conteudo', crumb_default + 'Adicionar conteúdo'
    end

    scenario 'estatísticas' do
      verificar_breadcrumbs '/estatisticas', crumb_default + 'Estatísticas'
    end

    scenario 'documentos mais acessados' do
      verificar_breadcrumbs '/documentos_mais_acessados', crumb_default + 'Documentos mais acessados'
    end

    scenario 'gráficos de acessos' do
      verificar_breadcrumbs '/graficos_de_acessos', crumb_default + 'Gráficos'
    end
  end

  context 'buscas' do
    scenario 'normal' do
      verificar_breadcrumbs(busca_normal_path, 'Busca normal') do |url|
        visit root_path
        fill_in "Busca", with: 'dummy '
        click_button "Buscar"
      end
    end

    context 'avançada' do
      scenario 'formulário' do
        verificar_breadcrumbs(buscas_path, 'Busca avançada')
      end

      scenario 'resultados' do
        verificar_breadcrumbs(buscas_path, 'Busca avançada') do |url|
          visit buscas_path
          click_button "Buscar"
        end
      end
    end
  end

  context 'conteúdos' do
    scenario 'novo' do
      popular_area_sub_area
      verificar_breadcrumbs(
        new_conteudo_path(tipo: :livro), crumb_default + 'Adicionar conteúdo')
    end

    scenario 'editar' do
      verificar_breadcrumbs(
        edit_conteudo_path(create :livro), crumb_default + 'Editar conteúdo')
    end
  end

  context 'páginas do usuário' do
    scenario 'área privada' do
      verificar_breadcrumbs(
        area_privada_usuario_path(@usuario), crumb_default + 'Área privada')
    end

    scenario 'minhas buscas' do
      verificar_breadcrumbs(
        minhas_buscas_usuario_path(@usuario), crumb_default + 'Minhas buscas')
    end

    scenario 'estante' do
      verificar_breadcrumbs(
        estante_usuario_path(@usuario), crumb_default + 'Estante')
    end

    scenario 'escrivaninha' do
      verificar_breadcrumbs(
        escrivaninha_usuario_path(@usuario), crumb_default + 'Escrivaninha')
    end

    scenario 'lista de revisão' do
      verificar_breadcrumbs(
        lista_de_revisao_usuario_path(@usuario),
        crumb_default + 'Lista de revisão')
    end
  end

  it 'formulário de contato' do
    verificar_breadcrumbs(new_formulario_contato_path,
      crumb_default + 'Contato')
  end

  it 'editor' do
    verificar_breadcrumbs('/editor', crumb_default + 'Editor')
  end
end
