FactoryGirl.define do
  factory :autor do
    nome 'Jose das Couves'
  end

  factory :area do
    sequence(:nome) {|n| "Nome#{n}" }
  end

  factory :sub_area do
    sequence(:nome) {|n| "Nome#{n}" }
    area
  end

  factory :conteudo do
    titulo "Conteudo interessante"
    sub_area
    campus 'Campos-Centro'
    autores { [Factory.create(:autor)] }
  end

  factory :artigo_de_evento, :parent => :conteudo do
  end
end
