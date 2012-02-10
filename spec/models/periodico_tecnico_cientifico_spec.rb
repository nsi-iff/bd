# encoding: utf-8

require 'spec_helper'

describe PeriodicoTecnicoCientifico do
  this_year = Date.today.year
  it { should have_valid(:ano_primeiro_volume).when '2010', '', nil }
  it { should_not have_valid(:ano_primeiro_volume).when '0', this_year + 1,
       'string' }

  it { should have_valid(:ano_ultimo_volume).when '2011', '', nil }
  it { should_not have_valid(:ano_ultimo_volume).when '0', this_year + 1,
       'string' }
end
