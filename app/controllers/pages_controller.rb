# encoding: utf-8

class PagesController < ApplicationController
  before_filter :authenticate_usuario!, only: [:adicionar_conteudo]
  load_and_authorize_resource Usuario, parent: false, only: [:adicionar_conteudo]

  def inicio
    @title = "Página Inicial"
  end

  def buscas
    @title = "Busca no Acervo"
  end

  def ajuda
    @title = "Ajuda"
  end

  def sobre
    @title = "Sobre"
  end

  def noticias
    @title = "Notícias"
  end

  def estatisticas
    @title = "Estatísticas"
    if params['select_ano']
      @estatisticas = Estatistica.new(params['select_ano'], params['select_mes'])
    end
  end

  def documentos_mais_acessados
    @title = "Documentos mais acessados"
    @estatisticas = Estatistica.new(Date.today.year)
  end

  def graficos_de_acessos
    @title = "Gráficos de acessos"
    @estatisticas = Estatistica.new(Date.today.year)
    gon.rabl "app/views/pages/estatisticas.json.rabl"
  end

  def adicionar_conteudo
  end
end
