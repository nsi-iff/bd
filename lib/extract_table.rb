def extract_table(content)
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
  style + table
end
