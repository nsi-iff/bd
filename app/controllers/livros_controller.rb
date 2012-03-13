class LivrosController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :submeter

  include NovoComAutor

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Livro enviado com sucesso'
  end

  def submeter
    livro = Livro.find(params[:livro_id])
    livro.submeter
    redirect_to livro_path(livro)
  end
end
