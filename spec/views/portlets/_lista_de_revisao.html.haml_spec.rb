#encoding: utf-8

require 'spec_helper'

describe "portlets/_lista_de_revisao.html.haml" do
  let(:usuario) { stub_model(Usuario, lista_de_revisao: []) }

  before :each do
    view.stub(:current_usuario).and_return(usuario)
  end

  it 'somente é mostrado para usuários com acesso à lista de revisao' do
    view.stub(:can?).with(:ter_lista_de_revisao, usuario).and_return(true)
    render
    rendered.should have_content 'Lista de Revisão'
  end

  it 'nao aparece para usuarios sem acesso' do
    view.stub(:can?).with(:ter_lista_de_revisao, usuario).and_return(false)
    render
    render.should_not have_content 'Lista de Revisão'
  end
  
  it 'mostra apenas um número fixo de itens' do
    Rails.application.config.limite_de_itens_nos_portlets = 4
    conteudos = (1..8).map do |n| 
      build(:conteudo, id: n, titulo: "Conteudo #{n}", created_at: Time.now)
    end
    usuario.stub(:lista_de_revisao).and_return(conteudos)
    view.stub(:can?).and_return(true)
    render
    (1..4).each {|n| rendered.should have_content "Conteudo #{n}" }
    (5..6).each {|n| rendered.should_not have_content "Conteudo #{n}" }
  end
end
