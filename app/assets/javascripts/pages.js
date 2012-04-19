var Estatisticas;
Estatisticas = {
    lista_de_documentos: function(numero, dados) {
        var acessos, i = 0;
        title = [];
        acessos = [];
        while(i < numero){
            title.push(dados[i].titulo);
            acessos.push(dados[i].numero_de_acessos);
            i++;
        }
        return [title, acessos];
    },
    lista_percentuais_conteudo: function(numero, dados) {
        var data, i;
        data = [];
        i = 0;
        while (i < numero) {
            data[i] = [dados[i][0],dados[i][1]]
            i++;
        }
        return data;
    },
    lista_percentuais_subarea: function(numero, dados) {
        var data, i;
        data = [];
        i = 0;
        while (i < numero) {
           data[i] = [dados[i][1], dados[i][0]];
          i++;
        }
        return data;
     },

    barra: function(div, data, label){
        $.jqplot(div, [data], {

            animate: !$.jqplot.use_excanvas,
            seriesDefaults:{
                renderer:$.jqplot.BarRenderer,
                pointLabels: { show: true }
            },
            axes: {
                xaxis: {
                    renderer: $.jqplot.CategoryAxisRenderer,
                    ticks: label
                }
            },
            highlighter: { show: false }
        });
    },
    pie: function(div, data) {
        $.jqplot (div, [data], 
            { 
              seriesDefaults: {
                renderer: jQuery.jqplot.PieRenderer, 
                rendererOptions: {
                  showDataLabels: true
                }
              }, 
              legend: { show:true, location: 'e' }
            }
        );
    }
    
};



jQuery(function() {
    if (window.location.pathname == '/graficos_de_acessos') {
    
        cinco_mais = gon.estatistica.cinco_documentos_mais_acessados;
        acessos = Estatisticas.lista_de_documentos(cinco_mais.length, cinco_mais);
        Estatisticas.barra('cinco_acessos',acessos[1],acessos[0]);

        total_acessos = gon.estatistica.documentos_mais_acessados
        todos_acessos = Estatisticas.lista_de_documentos(total_acessos.length, total_acessos)
        Estatisticas.barra('todos_acessos',todos_acessos[1],todos_acessos[0]);

        percentuais_conteudo = gon.estatistica.percentual_de_acessos_por_tipo_de_conteudo;
        conteudo_ = Estatisticas.lista_percentuais_conteudo(percentuais_conteudo.length, percentuais_conteudo);
        Estatisticas.pie('conteudo', conteudo_);

        percentuais_subarea = gon.estatistica.percentual_de_acessos_por_subarea_de_conhecimento;
        subarea_ = Estatisticas.lista_percentuais_subarea(percentuais_subarea.length, percentuais_subarea);
        Estatisticas.pie('subarea',subarea_);

    }
});