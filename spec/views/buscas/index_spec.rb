#encoding: utf-8

require 'spec_helper'

describe "buscas/index.html.haml" do
  before :each do
    Papel.criar_todos
    assign(:instituicoes, [])
    assign(:tipos_conteudo, [])
  end
  
  context 'estados do conteudo' do
    context 'editável' do
      it 'aparece para usuário admin e instituicao_admin' do
        %w(instituicao_admin admin).each do |papel|
          assign(:usuario, stub_usuario(papel, pode_buscar_por_estados?: true))
          render
          rendered.should have_selector("input[type=checkbox][value=editavel]")
        end
      end
      
      it 'não aparece para outros' do
        %w(gestor contribuidor membro).each do |papel|
          assign(:usuario, stub_usuario(papel, pode_buscar_por_estados?: true))
          render
          rendered.should have_selector("input[type=checkbox][value=pendente]")
          rendered.should_not have_selector("input[type=checkbox][value=editavel]")
        end
      end
    end
  end
  
  context 'opções de busca por estado' do
    before(:each) { Papel.create(nome: 'dummy', descricao: 'qq coisa') }
    
    it 'aparecem para usuarios que podem buscar por estado' do
      assign(:usuario, stub_usuario(:dummy, pode_buscar_por_estados?: true))
      render
      rendered.should have_css "ul#estado_do_conteudo"
    end
    
    it 'do contrario, nao aparecem' do
      assign(:usuario, stub_usuario(:dummy, pode_buscar_por_estados?: false))
      render
      rendered.should_not have_css "ul#estado_do_conteudo"
    end
    
    it 'nao aparecem para usuario anonimo' do
      assign(:usuario, nil)
      render
      rendered.should_not have_css "ul#estado_do_conteudo"
    end
  end
end
