require 'spec_helper'

describe Relatorio do
  it { should_not have_valid(:numero_paginas).when('a', 'b', 0, -1, -2) }
  it { should have_valid(:numero_paginas).when(1, 2, 3, '', nil) }

  this_year = Date.today.year
  it { should have_valid(:ano_publicacao).when(this_year, this_year-1, '', nil)}
  it { should_not have_valid(:ano_publicacao).when('a', 'b') }
end
