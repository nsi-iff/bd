# encoding: utf-8
require 'referencia_bibliografica'

class Conteudo < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include ReferenciaBibliografica
  include Referenciavel

  has_many :graos
  has_many :autores
  has_many :mudancas_de_estado
  belongs_to :sub_area
  has_one :arquivo
  belongs_to :contribuidor, :class_name => 'Usuario'
  accepts_nested_attributes_for :autores, :arquivo, :reject_if => :all_blank
  belongs_to :campus

  attr_accessible :arquivo, :contribuidor, :titulo, :link, :sub_area_id,
                  :autores_attributes, :campus_id, :contribuidor_id, :subtitulo,
                  :resumo, :direitos, :sub_area, :campus, :autores, :pronatec,
                  :arquivo_attributes

  validate :arquivo_deve_ser_valido, :if => :arquivo

  validate :nao_pode_ter_arquivo_e_link_simultaneamente,
           :arquivo_ou_link_devem_existir

  validates :titulo, :sub_area,
            :campus, :autores, presence: true

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

  def self.estados
    [:editavel, :pendente, :recolhido, :publicado]
  end

  def estados
    self.class.estados
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

  # TODO: refatorar
  def self.search(busca)
    busca_conteudos = Tire.search('conteudos', load: true) {
      query { string busca if busca }
    }.results.to_a
    busca_arquivos = Tire.search('arquivos', load: true) {
      query { string busca if busca }
    }.results.to_a
    (busca_conteudos + busca_arquivos.map(&:conteudo)).uniq
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
                      campus: { only: [:nome]},
                      graos: { only: [:tipo, :key] } },
            methods: [:data_publicado, :area_nome,
                      :sub_area_nome, :instituicao_nome])
  end

  # TODO: refatorar
  def area_nome
    self.try(:sub_area).try(:area).try(:nome)
  end

  def sub_area_nome
    self.try(:sub_area).try(:nome)
  end

  def instituicao_nome
    self.try(:campus).try(:instituicao).try(:nome)
  end

  def arquivo=(uploaded)
    return super(Arquivo.new uploaded_file: uploaded) if uploaded.respond_to?(:read)
    super
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

  def self.pendentes_da_instituicao(instituicao)
    campi_ids = instituicao.campus.map(&:id)
    where("campus_id IN (#{campi_ids.join(',')}) AND state = 'pendente'")
  end

  def extensao
    arquivo.nome.split('.').last
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

  def arquivo_deve_ser_valido
    if !self.arquivo.valid? and tipo_de_arquivo_importa?
      errors.add(:arquivo, "Arquivo inválido")
    end
  end

  def mesma_instituicao?(user, conteudo)
    camp1 = Campus.find(user.campus_id)
    camp2 = Campus.find(conteudo.campus_id)
    camp1.instituicao_id == camp2.instituicao_id
  end
end
