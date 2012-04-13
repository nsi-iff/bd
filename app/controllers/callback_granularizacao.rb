module CallbackGranularizacao
  def granularizou
    conteudo = Conteudo.encontrar_por_id_sam(params['doc_key'])
    conteudo.granularizou!(graos: params['grains_keys'])
    render nothing: true
  end
end

