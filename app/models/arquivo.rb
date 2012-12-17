#encoding: utf-8
class Arquivo < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  tire.mapping do
    indexes :id, :type => :string, :index => :not_analyzed
    indexes :content_base64, :type => :attachment
  end

  belongs_to :conteudo

  attr_accessor :uploaded_file
  attr_accessible :uploaded_file, :conteudo, :key, :thumbnail_key, :nome

  validates_format_of :nome, :with => /.*\.(pdf|rtf|odt|doc|ps)/, :on => :create,
                             :if => :tipo_importa?

  validate :checar_mimetype

  before_save :enviar_ao_sam
  before_destroy :deleta_do_sam, :if => "self.key"

  def checar_mimetype
    self.mime_type == 'application/ogg' && errors.add(:mime_type, 'Arquivo inválido')
  end

  def to_s
    self.nome
  end

  def odt?
    nome =~ /\.odt$/i
  end

  def video?
    self.mime_type.start_with? 'video'
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
    tmp_path = @uploaded_file.tempfile.path
    self.mime_type = `mimetype #{tmp_path}`.split(' ')[-1]
    @content_base64 = Base64.encode64 @uploaded_file.read
  end

  def enviar_ao_sam
    if @uploaded_file.present?
      self.key = sam.store(file: self.content_base64, filename: self.nome).key
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

  def salvar_se_necessario
    self.save if self.changed?
  end

  def deleta_do_sam
    resposta_arquivo = sam.delete(self.key)
    if self.thumbnail_key
      resposta_thumbnail = sam.delete(self.thumbnail_key)
      return resposta_arquivo.deleted? && resposta_thumbnail.deleted?
    else
      return resposta_arquivo.deleted?
    end
  end

  def extrair_metadados
    cloudooo = ServiceRegistry.cloudooo
    sam = ServiceRegistry.sam
    tipos_de_conteudo = {"artigo_de_evento" => "event",
                         "artigo_de_periodico" => 'period',
                         "trabalho_de_obtencao_de_grau" => 'tcc'}
    tipo_do_conteudo = tipos_de_conteudo[Conteudo.find(self.conteudo_id).nome_como_simbolo]
    chave_arquivo = self.key
    cloudooo.extract_metadata(chave_arquivo, tipo_do_conteudo)
    sleep(2)
    chave_metadados = cloudooo.metadata_key_for(chave_arquivo)
    metadados = sam.get(chave_metadados).data()
  end
end
