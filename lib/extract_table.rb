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
    odt_file = Tempfile.new("#{Rails.root}/tmp/arquivo.odt", "w")
    odt_file.write(content.force_encoding('UTF-8'))
    odt_file.close()
    zipfile = ZipFile.open(odt_file.path)
    images = table.scan(/Pictures\/(.+)\n/).flatten
    images.each do |image|
      index = table.index("Pictures/#{image}")
      open_image = zipfile.read("Pictures/#{image}")
      table["Pictures/#{image}"] = 
        "<span class='imagem_em_table'><img src='data:image/xyz;base64,#{Base64.encode64(image)}'></span>"
    end
  end
  style + table
end
