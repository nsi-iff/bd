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

  def calcular_quantidade_de_acessos
    @log_file ||= Rails.application.config.apache_log_file
    hoje = Time.new.day
    self.quantidade = extrair_registros.find_all {
      |registro| registro["%t"][1,2].to_i == hoje
    }.size
    self.data = Time.now
  end

  def self.total_de_acessos
    sum :quantidade
  end
end

