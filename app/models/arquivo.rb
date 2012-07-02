class Arquivo < ActiveRecord::Base
  belongs_to :conteudo

  attr_accessor :uploaded_file
  attr_accessible :nome, :conteudo, :mime_type, :key, :uploaded_file

  def to_s
    self.nome
  end

  def odt?
    nome =~ /\.odt$/i
  end

  def video?
    mime_type.start_with? 'video'
  end

  def base64
    Base64.encode64 @uploaded_file.try(:read).to_s
  end

  def uploaded_file=(uploaded_file)
    @uploaded_file = uploaded_file
    self.nome = @uploaded_file.original_filename
    self.mime_type = @uploaded_file.content_type
  end
end
