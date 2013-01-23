# encoding: utf-8

class PagesController < ApplicationController
  before_filter :authenticate_usuario!, only: [:adicionar_conteudo]

  def inicio
    @title = "Página Inicial"
  end

  def buscas
    @title = "Busca no Acervo"
  end

  def ajuda
    @title = "Ajuda"
  end

  def manuais
  end

  def sobre
    @title = "Sobre"
  end

  def estatisticas
    @title = "Estatísticas"
    unless params['select_ano']
      params['select_ano'] = Date.today.year
    end
    @estatisticas = Estatistica.new(params['select_ano'], params['select_mes'])
  end

  def por_conteudo_individual
    estatisticas_gerais_de_acesso
  end

  def por_tipo_de_conteudo
    estatisticas_gerais_de_acesso
  end

  def por_subarea_do_conhecimento
    estatisticas_gerais_de_acesso
  end

  def documentos_mais_acessados
    estatisticas_gerais_de_acesso
  end

  def adicionar_conteudo
    authorize! :create, Conteudo
  end

  def mapa_do_site
    @title = "Mapa do Site"
  end

  private

  def estatisticas_gerais_de_acesso
    @estatisticas = Estatistica.new(Date.today.year)
    gon.rabl "app/views/pages/estatisticas.json.rabl"
  end
end
