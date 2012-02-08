# encoding: utf-8

require 'spec_helper'

describe PeriodicoTecnicoCientifico do
  it { should have_valid(:ano_primeiro_volume).when '2010' }
  it { should_not have_valid(:ano_primeiro_volume).when '0', Time.now.year + 1 }

  it { should have_valid(:ano_ultimo_volume).when '2011' }
  it { should_not have_valid(:ano_ultimo_volume).when '0', Time.now.year + 1 }
end
