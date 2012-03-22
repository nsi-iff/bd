# encoding: utf-8

require 'spec_helper'

feature 'Editar Conteúdo' do
  context 'conteúdo em estado pendente ou recolhido' do
    tipos = %W(livro
               artigo_de_evento
               periodico_tecnico_cientifico
               relatorio
               artigo_de_periodico
               trabalho_de_obtencao_de_grau
               objeto_de_aprendizagem)

    scenario 'editar conteúdo' do
      criar_papeis
      autenticar_usuario(Papel.contribuidor)

      tipos.each do |tipo|
        conteudo = Factory.create tipo
        conteudo.submeter
        visit send("edit_#{tipo}_path", conteudo)
        page.should have_content 'Conteúdo não pode ser editado'
        current_path.should == send("#{tipo}_path", conteudo)
      end
    end
  end
end
