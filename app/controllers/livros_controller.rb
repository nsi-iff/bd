class LivrosController < InheritedResources::Base
  actions :new, :create, :show
  
  def create
    create! notice: 'Livro submetido com sucesso'
  end
end
