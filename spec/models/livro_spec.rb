require 'spec_helper'

describe Livro do
  it 'deve ter o atributo "traducao" false por default' do
    livro = Livro.new
    livro.save validate: false
    livro.traducao.should == false
  end

  it { should have_valid(:numero_edicao).when '4' }
  it { should have_valid(:numero_edicao).when '', nil }
  it { should_not have_valid(:numero_edicao).when '4 ed' }
  it { should_not have_valid(:numero_edicao).when '-1' }

  it { should have_valid(:numero_paginas).when '180' }
  it { should have_valid(:numero_paginas).when '', nil }
  it { should_not have_valid(:numero_paginas).when 'cento e oitenta' }
  it { should_not have_valid(:numero_paginas).when '-1' }
end
