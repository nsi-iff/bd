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
    options[:assigns].each do |var, value|
      assign(var, value)
    end if options[:assigns]
    Rails.application.config.limite_de_itens_nos_portlets = 4
    view.stub(:current_usuario).and_return(usuario || stub_model(Usuario))
    view.stub(:can?).and_return(true)
    render
    (1..4).each {|n| rendered.send options[:reverse] ? :should_not : :should, have_content("Conteudo #{n}") }
    (5..6).each {|n| rendered.send options[:reverse] ? :should : :should_not, have_content("Conteudo #{n}") }
  end
end
