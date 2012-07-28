# encoding: utf-8

require 'spec_helper'

describe SubArea do
  subject {
    create(:sub_area, area: stub_model(Area, nome: "Ciências"))
    }

  its(:nome_area) { should eq("Ciências") }

  it "deve ser valido quando associado a uma área" do
    area = create(:area)

    sub = SubArea.create(nome: "subarea", area: area)
    sub.should be_valid
  end

  it "deve ser invalido quando não associado a uma área" do
    SubArea.create(nome: "subarea").should_not be_valid
  end
end
