# encoding: utf-8

class Grau < ActiveRecord::Base
  has_many :trabalho_de_obtencao_de_grau
  def self.criar_todos
    create!([
        { nome: 'Graduação'      },
        { nome: 'Especialização' },
        { nome: 'Mestrado'       },
        { nome: 'Doutorado'      }
    ])
  end
  
  attr_accessible :nome
end
