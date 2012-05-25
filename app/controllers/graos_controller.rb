require './lib/zip_entry.rb'
require 'extend_string'

class GraosController < ApplicationController
  before_filter :carregar_grao, :if => :current_usuario

  def adicionar_a_cesta
    @cesta << params[:id]
    current_usuario.cesta << @grao if current_usuario.present?
    respond_to &:js
  end

  def remover_da_cesta
    @cesta.delete(params[:id])
    current_usuario.cesta.delete(@grao) if current_usuario.present?
    respond_to &:js
  end

   def baixar_conteudo
    unless current_usuario.cesta.blank?
      @sam = ServiceRegistry.sam
      t = Tempfile.new("cesta_temporaria", tmpdir="#{Rails.root}/tmp")
      Zip::ZipOutputStream.open(t.path) do |z|
        current_usuario.cesta.all.map(&:key).each_with_index do |key, index|
          grao = Grao.where(:key => key).first
          conteudo_que_gerou_o_grao = Conteudo.where(:id => grao.conteudo_id).first
          nome_conteudo = conteudo_que_gerou_o_grao.titulo.removeaccents.titleize.delete(" ").underscore
          tipo_grao = grao.tipo
          dados_grao = @sam.get(key)['data']
          title = 'grao_' + nome_conteudo +  '_' + index.to_s
          if tipo_grao == 'images'
            nome_grao = dados_grao['filename']
            formato_grao = nome_grao[-4..-1]
            title += formato_grao
          else
            title += '.odt'
          end
          z.put_next_entry(title)
          z.print Base64.decode64(dados_grao['file'])
        end
      end
    end
    send_file t.path, :type => 'application/zip',
                      :disposition => 'attachment',
                      :filename => 'cesta-' + Time.now.to_s + '.zip'
    t.close
  end

  def cesta
  end

  def favoritar_graos
    authorize! :favoritar, Grao
    current_usuario.graos_favoritos << current_usuario.cesta.all
    current_usuario.cesta = []
    redirect_to :back
  end

  def editar
    respond_to &:js
  end

  private

  def carregar_grao
    @grao = Grao.find(params[:id]) if params[:id]
  end
end

