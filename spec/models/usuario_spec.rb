require 'spec_helper'

describe Usuario do
  it { should have_valid(:email).when 'bernardo.fire@gmail.com', 'aeiou@abcd.com' }
  it { should_not have_valid(:email).when '', nil }

  it { should have_valid(:nome_completo).when 'Luke Skywalker', 'Darth Vader' }
  it { should_not have_valid(:nome_completo).when 'r2d2', '123456789', nil, '' }

  it { should have_valid(:instituicao).when 'ifto', 'IFF' }
  it { should_not have_valid(:instituicao).when '', nil }

  it { should have_valid(:campus).when 'Campus Centro', 'Campus Foo' }
  it { should_not have_valid(:campus).when '', nil }

  it 'responde se possui um determinado papel' do
    usuario = Usuario.new
    papeis = ['gestor', 'admin', 'contribuidor'].map {|nome|
      Papel.create!(nome: nome, descricao: 'dummy')
    }
    usuario.papeis = papeis[0..1]
    usuario.should be_gestor
    usuario.should be_admin
    usuario.should_not be_contribuidor
    expect { usuario.qqcoisa? }.to raise_error(NoMethodError)
  end
end

