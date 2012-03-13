# encoding: utf-8

class PeriodicosTecnicoCientificosController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :aprovar

  include NovoComAutor

  before_filter :authenticate_usuario!
  load_and_authorize_resource

  def create
    create! notice: 'Periódico técnico científico submetido com sucesso'
  end

  def aprovar
    periodico = PeriodicoTecnicoCientifico.find(params[:periodico_tecnico_cientifico_id])
    periodico.aprovar
    redirect_to periodico_tecnico_cientifico_path(periodico)
  end
end
