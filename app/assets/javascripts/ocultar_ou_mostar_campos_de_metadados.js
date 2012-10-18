function ocultar_metadados(){
  $('#metadados_basicos_dependentes_do_campo_link').hide();
  $('#metadados_complementares_dependentes_do_campo_link').hide();
  inserir_evento_no_campo_arquivo();
};

function mostrar_metadados(){
  $('#metadados_basicos_dependentes_do_campo_link').show();
  $('#metadados_complementares_dependentes_do_campo_link').show();
};

function inserir_evento_no_campo_arquivo(){
  var tipo = url_query("tipo");
  var string = "#" + tipo + "_arquivo_attributes_uploaded_file";
  $(string).focus(function(){ocultar_metadados();})
};

function url_query(query){
  query = query.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var expr = "[\\?&]"+query+"=([^&#]*)";
  var regex = new RegExp( expr );
  var results = regex.exec( window.location.href );
  if ( results !== null ) {
    return results[1];
  } else {
    return false;
  }
};
