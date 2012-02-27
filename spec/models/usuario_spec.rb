require 'spec_helper'

describe Usuario do
  it { should have_valid(:email).when 'bernardo.fire@gmail.com', 'aeiou@abcd.com' }
  it { should_not have_valid(:email).when '', nil }

  it { should have_valid(:nome_completo).when 'Luke Skywalker', 'Darth Vader' }
  it { should_not have_valid(:nome_completo).when 'r2d2', '123456789', nil, '' }

  it { should have_valid(:instituicao).when 'ifto', 'IFF' }
  it { should_not have_valid(:instituicao).when '', nil }

  it { should have_valid(:campus).when 'Campus Centro', 'Campus Foo' }
  it { should_not have_valid(:campus).when '', nil }
end
