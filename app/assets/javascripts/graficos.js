var Estatisticas = {
    lista_de_documentos: function(numero, dados) {
        title = [];
        var acessos = [];
        var i = 0;
        while (i < numero) {
            title.push(dados[i].titulo);
            acessos.push(dados[i].numero_de_acessos);
            i++;
        }
        return [title, acessos];
    },
    lista_percentuais_conteudo: function(numero, dados) {
        var data = [];
        var i = 0;
        while (i < numero) {
            data[i] = [dados[i][0], dados[i][1]];
            i++;
        }
        return data;
    },
    lista_percentuais_subarea: function(numero, dados) {
        var data = [];
        var i = 0;
        while (i < numero) {
            data[i] = [dados[i][1], dados[i][0]];
            i++;
        }
        return data;
    },

    barra: function(div, data, label, title) {
        $.jqplot(div, [data], {
            seriesDefaults: {
                renderer: $.jqplot.BarRenderer,
                pointLabels: {
                    show: true
                }
            },
            axes: {
                xaxis: {
                    renderer: $.jqplot.CategoryAxisRenderer,
                    ticks: label
                }
            },
            title: title,
            highlighter: {
                show: false
            }
          });
    },
    pie: function(div, data, title) {
        $.jqplot(div, [data], {
            seriesDefaults: {
                renderer: jQuery.jqplot.PieRenderer,
                rendererOptions: {
                    showDataLabels: true
                }
            },
            title: title,
            legend: {
                show: true,
                location: 'e'
            }
        });
    },
};

$(document).ready(function() {
    if (window.location.pathname == '/graficos_de_acessos') {
        $.jqplot.config.enablePlugins = true;
        cinco_mais = gon.estatistica.cinco_documentos_mais_acessados;
        acessos = Estatisticas.lista_de_documentos(cinco_mais.length, cinco_mais);
        title = 'Os cinco documentos mais acessados.';
        Estatisticas.barra('cinco_acessos', acessos[1], acessos[0], title);

        percentuais_conteudo = gon.estatistica.percentual_de_acessos_por_tipo_de_conteudo;
        conteudo_ = Estatisticas.lista_percentuais_conteudo(percentuais_conteudo.length, percentuais_conteudo);
        title = 'Acesso por tipo de conteudo.';
        Estatisticas.pie('conteudo', conteudo_, title);

        percentuais_subarea = gon.estatistica.percentual_de_acessos_por_subarea_de_conhecimento;
        subarea_ = Estatisticas.lista_percentuais_subarea(percentuais_subarea.length, percentuais_subarea);
        title = 'Acesso por subarea de conhecimento.';
        Estatisticas.pie('subarea', subarea_, title);

        total_acessos = gon.estatistica.documentos_mais_acessados;
        todos_acessos = Estatisticas.lista_de_documentos(total_acessos.length, total_acessos);
        title = 'Acesso de documentos por conteúdo individual.';
        Estatisticas.barra('todos_acessos', todos_acessos[1], todos_acessos[0], title);

        $('.salvar_grafico').click(function() {
          var grafico_id = this.id.replace('salvar_', '');
          $('#' + grafico_id).jqplotSaveImage();
        });
    }
});

