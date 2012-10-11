# encoding: utf-8

require 'spec_helper'

describe Referencia do
  it { should_not have_valid(:referenciavel).when nil }
  it { should_not have_valid(:abnt).when nil }

  it 'deve salvar refencia abnt do referenciavel quando criado' do
    conteudo = create(:artigo_de_periodico)
    grao = create(:grao, conteudo: conteudo)
    referencia = create(:referencia, referenciavel: grao)
    referencia.should be_valid
    referencia.abnt.should == grao.referencia_abnt
  end

  it 'nao deve exigir referenciavel se referencia ja existir' do
    referencia = create(:referencia)
    referencia.referenciavel = nil
    referencia.should be_valid
  end

  it 'deve salvar o tipo do grao se referenciavel for Grao' do
    conteudo = create(:artigo_de_periodico)
    grao = create(:grao, conteudo: conteudo)
    referencia = create(:referencia, referenciavel: grao)
    referencia.tipo_do_grao.should == grao.tipo
  end

  it 'deve enviar email para usuarios que o favoritaram' do
    grao = create(:grao, conteudo: create(:livro))
    usuario = create(:usuario)
    usuario.favoritos.create(referenciavel: grao)
    expect {
      grao.referencia.referenciavel_removido!
    }.to change { ActionMailer::Base.deliveries.size }.by 1

    email = ultimo_email_enviado
    email.to.should == [usuario.email]
    email.subject.should == 'Biblioteca Digital: Notificação sobre grão removido'
  end
  
  it 'retorna o referenciavel por id da referencia' do
    conteudo = create(:livro)
    referencia = create(:referencia, referenciavel: conteudo)
    Referencia.referenciavel_por_id_referencia(referencia.id).should == conteudo
    Referencia.referenciavel_por_id_referencia(-999).should be_nil
  end
end
