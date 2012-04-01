# encoding: utf-8

class Conteudo < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  has_many :graos
  has_many :autores
  has_many :mudancas_de_estado
  belongs_to :sub_area
  has_one :arquivo
  belongs_to :contribuidor, :class_name => 'Usuario'
  accepts_nested_attributes_for :autores, :reject_if => :all_blank
  has_and_belongs_to_many :usuarios

  validate :nao_pode_ter_arquivo_e_link_simultaneamente,
           :arquivo_ou_link_devem_existir,
           :tipo_de_arquivo

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
      transition :granularizando => :publicado, :if => :granularizado?
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
  end

  scope :editaveis, lambda {|contribuidor|
    where(:contribuidor_id => contribuidor.id, :state => 'editavel')
  }

  scope :pendentes, lambda {|contribuidor|
    where(:contribuidor_id => contribuidor.id, :state => 'pendente')
  }

  scope :publicados, lambda {|contribuidor|
    where(:contribuidor_id => contribuidor.id, :state => 'publicado')
  }

  def remover(*args)
    raise "O motivo é obrigatório" unless args.present? && args.first.has_key?(:motivo)
    super
  end

  def destruir_graos
    # STUB
  end

  def granularizavel?
    # STUB
    false
  end

  def granularizado?
    # STUB
    false
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
    to_json(include: { autores: { only: [:nome, :lattes] },
                       sub_area: { only: [:nome], include: {area: {only: [:nome]}} }},
            methods: [:arquivo_base64, :data_publicado])
  end

  alias  :set_arquivo :arquivo=

  def arquivo=(uploaded)
    @arquivo_uploaded = uploaded
    @arquivo_base64 = Base64.encode64(@arquivo_uploaded.read) if @arquivo_uploaded
  end

  private

  def vincular_arquivo
    if @arquivo_uploaded.present?
      set_arquivo(Arquivo.new(nome: @arquivo_uploaded.original_filename, conteudo: self))
    end
  end

  def enviar_arquivo_ao_sam
    if arquivo.present?
      config = Rails.application.config
      url = "http://#{config.sam_user}:#{config.sam_password}@#{config.sam_host}:#{config.sam_port}"
      sam = NSISam::Client.new url
      result = sam.store arquivo_base64
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
      unless self.class == ObjetoDeAprendizagem
        unless arquivo.nome =~/.*\.(pdf|rtf|odt|doc|ps)/
          errors.add(:arquivo, 'Tipo de arquivo não suportado para o conteúdo')
        end
      end
    end
  end
end
