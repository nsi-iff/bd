require 'spec_helper'

describe TrabalhoDeObtencaoDeGrau do
  it { should have_valid(:numero_paginas).when 1, 20, '', nil   }
  it { should_not have_valid(:numero_paginas).when 0, -5 }

  it { should have_valid(:data_defesa_br).when '', '01/06/1994', '03/10/1996' }
  it { should_not have_valid(:data_defesa_br).when '0', '2011/04/04', '03/2011/04' }
end
