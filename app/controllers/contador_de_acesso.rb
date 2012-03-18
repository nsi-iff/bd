module ContadorDeAcesso
  def incrementar_numero_de_acessos
    object = model_class.find(params[:id])
    if object.publicado?
      object.numero_de_acessos += 1
      object.save!
    end
  end
end
