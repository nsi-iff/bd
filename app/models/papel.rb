# encoding: utf-8

class Papel < ActiveRecord::Base
  has_and_belongs_to_many :usuarios

  def self.criar_todos
    create!([
      { nome: 'membro', descricao: 'membro' },
      { nome: 'contribuidor', descricao: 'contribuidor de conteúdo' },
      { nome: 'gestor', descricao: 'gestor de conteúdo' },
      { nome: 'admin', descricao: 'administrador' }
    ])
  end

  def self.method_missing(method_name, *params)
    where(nome: method_name).first || super
  end
end

