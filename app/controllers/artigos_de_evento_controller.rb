class ArtigosDeEventoController < InheritedResources::Base
  actions :new, :create, :show

  def create
    create! :notice => 'Artigo de evento submetido com sucesso'
  end
end
