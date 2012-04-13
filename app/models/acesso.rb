require 'time'
require 'apachelogregex'

class Acesso < ActiveRecord::Base

  attr_accessor :log_file
  before_save :calcular_quantidade_de_acessos
 
  def extrair_registros
    formato = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'
    parser = ApacheLogRegex.new(formato)
    File.open(@log_file).readlines.map { |linha| parser.parse(linha) }.compact  
  end

  def calcular_quantidade_de_acessos()
    @log_file ||= Rails.application.config.apache_log_file
    @hoje = Time.new.day
    @numero_de_registros = 0
    registros = extrair_registros
    registros.each do |registro|
      dia_do_acesso = registro["%t"][1,2].to_i
      if dia_do_acesso == @hoje
        @numero_de_registros += 1
      end
    end
    self.data = Time.now
    self.quantidade = @numero_de_registros  
  end

  def self.total_de_acessos
    self.sum :quantidade
  end

end
