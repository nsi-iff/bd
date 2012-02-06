# encoding: utf-8

class Conteudo < ActiveRecord::Base
  has_many :autores
  accepts_nested_attributes_for :autores, :reject_if => :all_blank
  validate :nao_pode_ter_arquivo_e_link_simultaneamente

  private

  def nao_pode_ter_arquivo_e_link_simultaneamente
    if arquivo.present? && link.present?
      errors.add(:arquivo, 'não pode existir simultaneamente a link')
      errors.add(:link, 'não pode existir simultaneamente a arquivo')
    end
  end
end
