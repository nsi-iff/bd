require "spec_helper"

describe Campus do
  subject {
    create(:campus, instituicao: stub_model(Instituicao, nome: "IFF"))
    }

  its(:nome_instituicao) { should eq("IFF") }
end
