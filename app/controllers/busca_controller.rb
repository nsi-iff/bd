class BuscaController < ApplicationController
  def index
    if params[:busca]
      @conteudos = Conteudo.search params[:busca]
      session[:ultima_busca] = params[:busca]
    else
      @conteudos = []
    end
  end
end
