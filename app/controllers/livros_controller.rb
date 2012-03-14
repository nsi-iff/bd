class LivrosController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :submeter, :aprovar

  include NovoComAutor
  include WorkflowActions

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Livro enviado com sucesso'
  end

  def aprovar
    livro = Livro.find(params[:livro_id])
    livro.aprovar
    redirect_to livro_path(livro)
  end
end

