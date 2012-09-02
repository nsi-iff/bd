class Arquivo < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  tire.mapping do
    indexes :id, :type => :string, :index => :not_analyzed
    indexes :content_base64, :type => :attachment
  end

  belongs_to :conteudo

  attr_accessor :uploaded_file
  attr_accessible :uploaded_file, :conteudo

  validates_format_of :nome, :with => /.*\.(pdf|rtf|odt|doc|ps)/, :on => :create,
                             :if => :tipo_importa?
  before_save :enviar_ao_sam

  def to_s
    self.nome
  end

  def odt?
    nome =~ /\.odt$/i
  end

  def video?
    mime_type.start_with? 'video'
  end

  def content_base64
    @content_base64 || ""
  end

  def to_indexed_json
    to_json(methods: [:content_base64])
  end

  def uploaded_file=(uploaded_file)
    @uploaded_file = uploaded_file
    self.nome = @uploaded_file.original_filename
    self.mime_type = @uploaded_file.content_type
    @content_base64 = Base64.encode64 @uploaded_file.read
  end

  def enviar_ao_sam
    if @uploaded_file.present?
      self.key = sam.store(file: self.content_base64).key
    end
  end

  def tipo_importa?
    conteudo ? conteudo.tipo_de_arquivo_importa? : true
  end

  def extensao
    nome.split('.').last
  end

  def thumbnail
    sam.get(self.thumbnail_key).data['file'] if self.thumbnail_key
  end
end
