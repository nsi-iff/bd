# encoding: utf-8

class PeriodicosTecnicoCientificosController < InheritedResources::Base
  actions :new, :create, :show

  def create
    create! notice: 'Periódico técnico científico submetido com sucesso'
  end
end
