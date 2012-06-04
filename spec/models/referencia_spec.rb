require 'spec_helper'

describe Referencia do
  it { should_not have_valid(:referenciavel).when nil }
  it { should_not have_valid(:usuario).when nil }
  it { should_not have_valid(:abnt).when nil }
end
