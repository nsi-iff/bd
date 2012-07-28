require 'spec_helper'

describe Livro do
  it 'deve ter o atributo "traducao" false por default' do
    create(:livro).traducao.should be_false
  end

  it { should have_valid(:numero_edicao).when '4', '', nil }
  it { should_not have_valid(:numero_edicao).when '4 ed', '-1' }

  it { should have_valid(:numero_paginas).when '180', '', nil }
  it { should_not have_valid(:numero_paginas).when 'cento e oitenta', '-1' }

  it { should have_valid(:ano_publicacao).when '', '1994', '2012' }
  it { should_not have_valid(:ano_publicacao).when 'mil e novecentos', '1889' }
end
