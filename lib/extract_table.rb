require 'nokogiri'
require 'zip/zip'
require 'zip/zip_file'
require 'zip/zipfilesystem'

def extract_tables(content)
  file_name = "#{::Rails.root}/tmp/#{rand}.zip"
  File.open(file_name, 'wb') {|f| f.write(content) }
  odt = Zip::ZipFile.open(file_name)
  doc = Nokogiri::XML(odt.read('content.xml'))
  tables = doc.xpath('//table:table').count
  result_tables = []
  tables.times do |table_index|
    result_table = "<table id='extracted_table_#{table_index + 1}'>"
    rows = doc.xpath("//table:table[position()=#{table_index + 1}]/table:table-row").count
    rows.times do |row_index|
      cells = doc.xpath("//table:table[position()=#{table_index + 1}]/table:table-row[position()=#{row_index + 1}]/table:table-cell")
      result_table +=  '<tr>' +
        cells.map {|cell| "<td>#{cell.content}</td>" }.join +
        '</tr>'
    end
    result_table += '</table>'
    result_tables << result_table
  end
  result_tables
end

##odt = Zip::ZipFile.open('./spec/resources/grao_teste_2.odt')
#odt = Zip::ZipFile.open_buffer(File.read('./spec/resources/grao_teste_2.odt'))
#doc = Nokogiri::XML(odt.read('content.xml'))
#rows = doc.xpath('//table:table/table:table-row').count
#result = '<html><head><meta http-equiv="content-type" content="text/html;charset=UTF-8" /></head><body><table>'
#rows.times do |row_index|
#  result += '<tr>'
#  cells = doc.xpath("//table:table/table:table-row[position()=#{row_index + 1}]/table:table-cell")
#  cells.each do |cell|
#    result += "<td>#{cell.content}</td>"
#  end
#  result += '</tr>'
#end
#result += '</table></body></html>'
#File.open('./tmp/result_table.html', 'w') {|f| f.write(result) }
#`firefox ./tmp/result_table.html &`
