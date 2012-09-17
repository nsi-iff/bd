# encoding: utf-8

require 'spec_helper'

describe FormularioContato do
  describe 'validacoes' do
    it { should_not have_valid(:nome).when(nil, '') }
    it { should_not have_valid(:email).when(nil, '', 'aaa', 'a@a') }
    it { should_not have_valid(:assunto).when(nil, '') }
    it { should_not have_valid(:mensagem).when(nil, '') }
  end
end
