class BuscaController < ApplicationController
  def index
    if params[:busca]
      @conteudos = Conteudo.search params[:busca]
    else
      @conteudos = []
    end
  end
end
