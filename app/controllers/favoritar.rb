module Favoritar
  def favoritar
    conteudo = Conteudo.find(params["#{model_object_name}_id"])
    current_usuario.favoritos << conteudo
    redirect_to conteudo
  end

  def remover_favorito
    conteudo = Conteudo.find(params["#{model_object_name}_id"])
    current_usuario.favoritos.delete conteudo
    redirect_to conteudo
  end
end

