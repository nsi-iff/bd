# encoding: utf-8

class Instituicao < ActiveRecord::Base
  has_many :campi

  validates :nome, presence: true, uniqueness: true

  NENHUMA = 'Não pertenço a uma Instituição da Rede Federal de EPCT'

  def usuarios
    campi.map { |campus| campus.usuarios }.flatten
  end

  def to_s
    self.nome
  end
end
