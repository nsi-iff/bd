#encoding: utf-8
require 'spec_helper'

describe "conteudos/show.html.haml" do
  before :each do
    Papel.criar_todos
  end
  
  describe 'botao excluir' do    
    before(:each) do
      campus = create(:campus)
      sign_in :usuario, create(:usuario_gestor, campus: campus)
      @conteudo = create(:livro_pendente, campus: campus)
      view.stub(:conteudo).and_return(@conteudo)
      view.stub(:can?).and_return(true)
    end
    
    it 'mostra quando autorizado a excluir' do
      view.stub(:can?).with(:destroy, @conteudo).and_return(true)
      render
      rendered.should have_button 'Excluir'
    end
    
    it 'nao mostra quando nao autorizado a excluir' do
      view.stub(:can?).with(:destroy, @conteudo).and_return(false)
      render
      rendered.should_not have_button 'Excluir'
    end
  end
end
