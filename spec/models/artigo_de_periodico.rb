require 'spec_helper'

describe ArtigoDePeriodico do
  it { should have_valid(:volume_publicacao).when 1, 20, '' }
  it { should_not have_valid(:volume_publicacao).when 0, -5 }
end
