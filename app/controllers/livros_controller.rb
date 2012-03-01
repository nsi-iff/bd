class LivrosController < InheritedResources::Base
  actions :new, :create, :show

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Livro submetido com sucesso'
  end
end

