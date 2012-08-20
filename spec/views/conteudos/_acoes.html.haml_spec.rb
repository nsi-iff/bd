#encoding: utf-8
require 'spec_helper'

describe "conteudos/_acoes.html.haml" do
  before :each do
    Papel.criar_todos
    @campus = create(:campus)
    conteudo = create(:relatorio_pendente, campus: @campus)
    view.stub(:conteudo).and_return(conteudo)
  end

  context 'botão aprovar' do
    context 'usuario gestor' do
      it 'aparece se o gestor e da mesma instituicao do conteudo' do
        sign_in :usuario, create(:usuario_gestor, campus: @campus)
        render
        rendered.should have_button 'Aprovar'
      end

      it 'nao aparece se o gestor nao e da mesma instituicao do conteudo' do
        sign_in :usuario, create(:usuario_gestor, campus: create(:campus))
        render
        rendered.should_not have_button 'Aprovar'
      end
    end

    context 'usuario nao gestor' do
      it 'nao aparece' do
        sign_in :usuario, build(:usuario_contribuidor)
        render
        rendered.should_not have_button 'Aprovar'
      end
    end
  end
end
