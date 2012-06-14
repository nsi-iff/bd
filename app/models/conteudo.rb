# encoding: utf-8
require 'referencia_bibliografica'

class Conteudo < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include ReferenciaBibliografica

  has_many :graos
  has_many :autores
  has_many :mudancas_de_estado
  has_many :referencias, :as => :referenciavel
  belongs_to :sub_area
  has_one :arquivo
  belongs_to :contribuidor, :class_name => 'Usuario'
  accepts_nested_attributes_for :autores, :reject_if => :all_blank
  belongs_to :campus

  validate :nao_pode_ter_arquivo_e_link_simultaneamente,
           :arquivo_ou_link_devem_existir
  validate :tipo_de_arquivo, :if => :tipo_de_arquivo_importa?

  validates :titulo, :sub_area,
            :campus, :autores, presence: true

  before_validation :vincular_arquivo
  before_create :enviar_arquivo_ao_sam

  state_machine :state, :initial => :editavel do
    event :submeter do
      transition :editavel => :pendente
    end

    event :aprovar do
      transition :pendente => :granularizando, :if => :granularizavel?
      transition :pendente => :publicado
    end

    event :devolver do
      transition [:publicado, :recolhido, :pendente] => :editavel
    end

    event :granularizou do
      transition :granularizando => :publicado
    end

    event :falhou_granularizacao do
      transition :granularizando => :pendente
    end

    event :remover do
      transition [:pendente, :recolhido] => :removido
    end

    event :recolher do
      transition :publicado => :recolhido
    end

    event :publicar do
      transition :recolhido => :publicado
    end

    after_transition(any => any) do |conteudo, transicao|
      conteudo.mudancas_de_estado.create!(
        { de: transicao.from,
          para: transicao.to }.merge(transicao.args.first || {}))
    end

    after_transition any => :editavel, :do => :destruir_graos
    before_transition :pendente => :granularizando, :do => :granularizar
  end

  def remover(*args)
    raise "O motivo é obrigatório" unless args.present? && args.first.has_key?(:motivo)
    super
  end

  def granularizou(*args)
    options = args.first
    graos_response = options.delete(:graos)
    criar_graos(graos_response)
    super
  end

  def destruir_graos
    # STUB
  end

  def granularizavel?
    arquivo.present? && arquivo.odt?
  end

  def area
    self.sub_area.area
  end

  def estado
    state
  end

  def nome_contribuidor
    contribuidor.try(:nome_completo)
  end

  def self.search(busca)
    s = Tire.search 'conteudos' do
      query { string busca }
    end
    s.results
  end

  def arquivo_base64
    @arquivo_base64 || ""
  end

  def data_publicado
    if publicado?
      mudanca = MudancaDeEstado.where(conteudo_id: id, para: 'publicado')
      if mudanca.present?
        mudanca[0].data_hora.strftime("%d/%m/%y")
      else
        Time.now.strftime("%d/%m/%y")
      end
    end
  end

  def to_indexed_json
    to_json(include: {autores: { only: [:nome, :lattes]},
                      sub_area: { only: [:nome], include: {area: {only: [:nome]}}},
                      campus: { only: [:nome]},
                      graos: { only: [:tipo, :key] } },
            methods: [:arquivo_base64, :data_publicado])
  end

  alias  :set_arquivo :arquivo=

  def arquivo=(uploaded)
    @arquivo_uploaded = uploaded
    @arquivo_base64 = Base64.encode64(@arquivo_uploaded.read) if @arquivo_uploaded
  end

  def self.encontrar_por_id_sam(id_sam)
    Arquivo.find_by_key(id_sam).try(:conteudo)
  end

  def graos_arquivo
    graos.select(&:arquivo?)
  end

  def graos_imagem
    graos.select(&:imagem?)
  end

  def nome_humanizado
    nome_como_simbolo.humanize
  end

  def nome_como_simbolo
    self.class.name.underscore
  end

  def tipo_de_arquivo_importa?
    true
  end

  private

  def granularizar
    config = Rails.application.config.cloudooo_configuration
    cloudooo.granulate(
      sam_uid: arquivo.key,
      filename: arquivo.nome,
      callback: config[:callback_url],
      verb: config[:callback_verb])
  end

  def criar_graos(dados_graos)
    dados_graos.keys.each do |tipo|
      dados_graos[tipo].each {|key| graos.create!(key: key, tipo: tipo) }
    end
  end

  def vincular_arquivo
    if @arquivo_uploaded.present?
      set_arquivo(Arquivo.new(nome: @arquivo_uploaded.original_filename, conteudo: self, mime_type: @arquivo_uploaded.content_type))
    end
  end

  def enviar_arquivo_ao_sam
    if arquivo.present?
      result = sam.store(doc: arquivo_base64)
      arquivo.key = result['key']
    end
  end

  def nao_pode_ter_arquivo_e_link_simultaneamente
    if arquivo.present? && link.present?
      errors.add(:arquivo, 'não pode existir simultaneamente a link')
      errors.add(:link, 'não pode existir simultaneamente a arquivo')
    end
  end

  def arquivo_ou_link_devem_existir
    if arquivo.blank? && link.blank?
      errors.add(:arquivo, 'deve ser fornecido (ou informe um link)')
      errors.add(:link, 'deve ser informado (ou forneça um arquivo)')
    end
  end

  def tipo_de_arquivo
    if arquivo.present?
      unless arquivo.nome =~/.*\.(pdf|rtf|odt|doc|ps)/
        errors.add(:arquivo, 'tipo de arquivo não suportado')
      end
    end
  end
end
