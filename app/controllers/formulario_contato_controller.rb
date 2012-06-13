#encoding: utf-8

class FormularioContatoController < ApplicationController
  def new
    @formulario_contato = FormularioContato.new
  end

  def create
    begin
      @formulario_contato = FormularioContato.new(params[:formulario_contato])
      @formulario_contato.request = request
      if @formulario_contato.deliver
        flash.now[:notice] = 'Obrigado por entrar em contato'
      else
        render :new
      end
    rescue ScriptError
      flash[:error] = 'Desculpe, essa mensagem parece ser um spam e não foi entregue.'
    end
  end
end
