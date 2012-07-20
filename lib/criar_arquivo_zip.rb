def criar_arquivo_zip(cesta_de_graos)
  unless cesta_de_graos.blank?
    @sam = ServiceRegistry.sam
    t = Tempfile.new("cesta_temporaria", tmpdir="#{Rails.root}/tmp")
    @referencias_abnt = ""
    Zip::ZipOutputStream.open(t.path) do |z|
      cesta_de_graos.all.map {|referencia|
        referencia.referenciavel.key
      }.each_with_index do |key, index|
        grao = Grao.where(:key => key).first
        conteudo_que_gerou_o_grao = Conteudo.where(:id => grao.conteudo_id).first
        nome_conteudo = conteudo_que_gerou_o_grao.titulo.removeaccents.titleize.delete(" ").underscore
        dados_grao = @sam.get(key)['data']
        title = 'grao_' + nome_conteudo +  '_' + index.to_s
        if grao.imagem?
          nome_grao = dados_grao['filename']
          formato_grao = nome_grao[-4..-1]
          title += formato_grao
        else
          title += '.odt'
        end
        @referencias_abnt << "#{title}: #{conteudo_que_gerou_o_grao.referencia_abnt}\n"
        z.put_next_entry(title)
        z.print Base64.decode64(dados_grao['file'])
      end
      z.put_next_entry "referencias_ABNT.txt"
      z.print @referencias_abnt
    end
  end
  t.close()
  t.path
end
