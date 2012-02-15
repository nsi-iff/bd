# encoding: utf-8

class Conteudo < ActiveRecord::Base
  has_many :autores
  belongs_to :sub_area
  accepts_nested_attributes_for :autores, :reject_if => :all_blank

  validate :nao_pode_ter_arquivo_e_link_simultaneamente,
           :arquivo_ou_link_devem_existir

  validates :titulo, :sub_area,
            :campus, :autores, presence: true

  state_machine :initial => :editavel do
    event :submeter do
      transition :editavel => :pendente
    end

    event :aprovar do
      transition :pendente => :granularizando, :if => :granularizavel?
      transition :pendente => :publicado
    end

    event :reprovar do
      transition :pendente => :reprovado
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

  private

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
end
