def extract_table(content)
  if content.start_with? "<html>" # if file comes from pdf it came as html
    content =~ /\<body\>(.+)\<\/body\>/
    table = $1
    style = ''
  else
    file_name = "#{::Rails.root}/tmp/#{rand}.zip"
    File.open(file_name, 'wb') {|f| f.write(content) }

    ODT2HTML::Base.class_eval do
      define_method :get_options do
        @input_filename = file_name
      end
    end
    generated_html = ODT2HTML::Base.new.convert
    htmldoc = Nokogiri::HTML(generated_html)
    style = htmldoc.xpath('//style').to_s
    table = htmldoc.xpath('//table').to_s

    File.delete(file_name)
    while "Pictures".in? table
      index2 = index1 = table.index("Pictures")
      while table[index2] != "\n"
        index2 += 1
      end
      nome_imagem = table[index1..index2-1]
      arquivo_odt = Tempfile.new("#{Rails.root}/tmp/arquivo.odt", "w")
      arquivo_odt.write(content.force_encoding('UTF-8'))
      arquivo_odt.close()
      imagem = ZipFile.open(arquivo_odt.path).read(nome_imagem)
      (index2 - index1).times{ table[index1] = "" }
      table.insert(index1, "<span class='imagem_em_table'><img src='data:image/xyz;base64,#{Base64.encode64(imagem)}'></span>")
    end
  end
  style + table
end
