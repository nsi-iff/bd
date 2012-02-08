FactoryGirl.define do
  factory :autor do
    nome 'Jose das Couves'
  end

  factory :conteudo do
    titulo "Conteudo interessante"
    grande_area_de_conhecimento 'Grande Area'
    area_de_conhecimento 'Sub area'
    campus 'Campos-Centro'
    autores { [Factory.create(:autor)] }
  end

  factory :artigo_de_evento, :parent => :conteudo do
  end
end
