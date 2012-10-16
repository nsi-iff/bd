# encoding: utf-8

def escrivaninha_vazia
  'Não há nenhum conteúdo editável.'
end

def estante_vazia
  'Não há nenhum conteúdo pendente.'
end

shared_examples_for 'a portlet' do
  let(:usuario) { options[:usuario] }
  
  before(:each) do
    options[:assigns].each do |var, value|
      assign(var, value)
    end if options[:assigns]
    
    view.stub(:current_usuario).and_return(usuario || stub_model(Usuario))
    view.stub(:can?).and_return(true)
  end
  
  describe 'limitação da quantidade de itens' do  
    it 'mostra apenas um número fixo de itens' do
      Rails.application.config.limite_de_itens_nos_portlets = 4
      render
      (1..4).each {|n| rendered.send options[:reverse] ? :should_not : :should, have_content("Conteudo #{n}") }
      (5..6).each {|n| rendered.send options[:reverse] ? :should : :should_not, have_content("Conteudo #{n}") }
    end
  end

  describe 'link "Ver todos"' do
    it 'não mostra link "ver todos" quando todos os itens estão no portlet' do
      Rails.application.config.limite_de_itens_nos_portlets = 10
      render
      rendered.should_not have_content 'Ver todos'
    end
  end
end
