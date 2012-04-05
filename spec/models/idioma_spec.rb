require 'spec_helper'

describe Idioma do
  it 'sempre ordenado por descricao' do
    Idioma.destroy_all
    %w(Zzz Www Bbb Aaa).each {|desc| Idioma.create! descricao: desc }
    Idioma.all.map(&:descricao).should == %w(Aaa Bbb Www Zzz)
  end
end
