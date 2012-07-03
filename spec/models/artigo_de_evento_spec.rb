require 'spec_helper'

describe ArtigoDeEvento do
  it { should have_valid(:ano_publicacao).when 1990, 2000 }
  it { should_not have_valid(:ano_publicacao).when 1989, 1900 }
end
