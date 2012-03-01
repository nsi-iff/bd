class UsuariosController < InheritedResources::Base
  def index
    @usuarios = Usuario.all
    @papeis = Papel.all
  end
end
