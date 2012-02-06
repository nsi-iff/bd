FactoryGirl.define do
  factory :conteudo do
  end

  factory :artigo_de_evento, :parent => :conteudo do
  end
end
