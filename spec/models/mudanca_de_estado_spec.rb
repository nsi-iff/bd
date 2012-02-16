require 'spec_helper'

describe MudancaDeEstado do
  it 'possui data_hora igual a created_at' do
    subject.stub(:created_at).and_return(:dummy)
    subject.data_hora.should == :dummy
  end
end
