# encoding: utf-8

require 'spec_helper'

describe Grao do
  it 'responde se é do tipo arquivo' do
    build(:grao_arquivo).should be_arquivo
    Grao.new(tipo: 'outra coisa').should_not be_arquivo
  end

  it 'responde se é do tipo imagem' do
    build(:grao_imagem).should be_imagem
    Grao.new(tipo: 'outra coisa').should_not be_imagem
  end

  it 'informa seu tipo de modo humanizado' do
    build(:grao_imagem).tipo_humanizado.should == 'imagem'
    build(:grao_arquivo).tipo_humanizado.should == 'arquivo'
    Grao.new(tipo: 'outra coisa').tipo_humanizado.should be_nil
  end

  it 'possui metodo referencia_abnt referenciando seu conteudo' do
    conteudo = create(:livro)
    conteudo.should_receive(:referencia_abnt).and_return('referencia abnt')
    grao = create(:grao, conteudo: conteudo)
    grao.referencia_abnt.should == 'referencia abnt'
  end

  it 'deve executar metodo notificar_usuarios_sobre_remocao quando for removido' do
    conteudo = create(:livro)
    grao = create(:grao, conteudo: conteudo)
    grao.should_receive(:notificar_usuarios_sobre_remocao)
    grao.destroy
  end

  it 'deve enviar email para usuarios que o favoritaram quando for removido' do
    usuario = create(:usuario)
    conteudo = create(:livro)
    grao = create(:grao, conteudo: conteudo)
    usuario.favoritos.create(referenciavel: grao)
    expect { grao.destroy }.to change { ActionMailer::Base.deliveries.size }.by 1

    email = ActionMailer::Base.deliveries.last
    email.to.should == [usuario.email]
    email.subject.should == 'Biblioteca Digital: Notificação sobre grão removido'
  end
end
