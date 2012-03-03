# encoding: utf-8

class PagesController < ApplicationController
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
