# encoding: utf-8

class PagesController < ApplicationController
  before_filter :authenticate_usuario!
  load_and_authorize_resource Usuario, parent: false, only: [:adicionar_conteudo]

  def inicio
    @title = "Página Inicial"
  end

  def busca
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

  def adicionar_conteudo
  end
end
