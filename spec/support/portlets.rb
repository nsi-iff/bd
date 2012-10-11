# encoding: utf-8

def escrivaninha_vazia
  'Não há nenhum conteúdo editável.'
end

def estante_vazia
  'Não há nenhum conteúdo pendente.'
end

shared_examples_for 'a portlet' do
  it 'mostra apenas um número fixo de itens' do
    Rails.application.config.limite_de_itens_nos_portlets = 4
    conteudos_para_a_lista = (1..8).map do |n| 
      FactoryGirl.create(:conteudo, id: n, titulo: "Conteudo #{n}", created_at: Time.now)
    end
    view.stub(:current_usuario).and_return(stub_usuario[conteudos_para_a_lista])
    view.stub(:can?).and_return(true)
    render
    (1..4).each {|n| rendered.should have_content "Conteudo #{n}" }
    (5..6).each {|n| rendered.should_not have_content "Conteudo #{n}" }
  end
end
