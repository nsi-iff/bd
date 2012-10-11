# encoding: utf-8

def escrivaninha_vazia
  'Não há nenhum conteúdo editável.'
end

def estante_vazia
  'Não há nenhum conteúdo pendente.'
end

shared_examples_for 'a portlet' do
  let(:usuario) { options[:usuario] }
  
  it 'mostra apenas um número fixo de itens' do
    assigns.merge(options[:assigns]) if options[:assigns]
    Rails.application.config.limite_de_itens_nos_portlets = 4
    view.stub(:current_usuario).and_return(usuario)
    view.stub(:can?).and_return(true)
    render
    (1..4).each {|n| rendered.should have_content "Conteudo #{n}" }
    (5..6).each {|n| rendered.should_not have_content "Conteudo #{n}" }
  end
end
