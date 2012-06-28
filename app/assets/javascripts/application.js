// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require cocoon
//= require ckeditor/init
//= require_tree .

$(document).ready(function() {
    $(".mala_direta_checkbox").change(function() {
        var busca_id = this.value;
        var acao = this.checked ? "/cadastrar" : "/remover";
        $.post("/buscas/" + busca_id + acao + "_mala_direta");
    });

    $.ajaxSetup({
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
    }});

    $("#instituicao").change(function() {
        var id = this.value;
        $.post("/instituicoes/" + id + "/campus");
    });

    $("#check-all").change(function() {
        for(i=0; i<$(".check-one").length; i++) {
          $(".check-one")[i].checked = this.checked;
        }
    });
});
