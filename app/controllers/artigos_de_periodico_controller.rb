class ArtigosDePeriodicoController < InheritedResources::Base
  actions :new, :create, :show

  def create
    create! notice: 'Artigo de periodico submetido com sucesso'
  end
end
