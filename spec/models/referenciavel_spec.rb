# encoding: utf-8

require 'spec_helper'

describe Referenciavel do
  def fabrica(klass)
    klass.name.underscore.to_sym
  end

  context 'obtenção de referência' do
    it 'obtém referência existente' do
      [Livro, Grao].each do |klass|
        objeto = create(fabrica(klass))
        referencia = Referencia.create!(referenciavel: objeto)
        klass.find(objeto.id).referencia.should == referencia
      end
    end

    it 'se não existir, cria e retorna' do
      [Livro, Grao].each do |klass|
        objeto = create(fabrica(klass), referencia: nil)
        objeto.referencia.should be_kind_of Referencia
      end
    end
  end

  context 'notificação de exclusão' do
    it 'deve notificar sua exclusão à referência' do
      [Livro, Grao].each do |klass|
        objeto = create(fabrica(klass))
        objeto.should_receive(:deleta_do_sam).and_return(true) if objeto.kind_of? Grao
        referencia = objeto.referencia
        referencia.should_receive(:referenciavel_removido!)
        objeto.destroy
      end
    end
  end
end
