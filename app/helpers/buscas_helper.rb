# encoding: utf-8

module BuscasHelper
  def estados_visiveis_para(usuario)
    saida = "<label> #{check_box_tag 'parametros[estados][]', 'pendente'} Pendente </label>"
    saida += "<label> #{check_box_tag 'parametros[estados][]', 'publicado'} Publicado </label>"
    saida += "<label> #{check_box_tag 'parametros[estados][]', 'recolhido'} Recolhido </label>"

    if usuario.instituicao_admin? || usuario.admin?
      saida += "<label> #{check_box_tag 'parametros[estados][]', 'editavel'} Editável </label>"
    end
    saida.html_safe
  end
end