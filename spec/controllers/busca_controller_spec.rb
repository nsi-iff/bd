# encoding: UTF-8

require 'spec_helper'

describe BuscaController do

  describe "GET 'index'" do
    it "atribui um array vazio a @conteudos se não houver parâmetro de busca" do
      get 'index'
      assigns[:conteudos].should == []
    end

    it "atribui os items resultantes da pesquisa a @conteudos se houver parâmetro de busca" do
      result = mock(:result)
      Conteudo.should_receive('search').with('busca').and_return(result)
      get 'index', busca: "busca"
      assigns(:conteudos).should be(result)
    end
  end
end
