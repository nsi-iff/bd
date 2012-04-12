//TODO: colocar ano selecionado por padrao (na view ruby) (2012-04-12, 17:39, ciberglo)`
//TODO: refatorar (2012-04-12, 17:39, ciberglo)`
//TODO: remover funções do contexto global (2012-04-12, 23:37, ciberglo)`
function ano()
{
    if ($('#select_mes')[0].disabled == false)
        $('#select_mes')[0].disabled = true;
    $('#select_ano')[0].disabled = false;
}

function mes()
{
    if ($('#select_ano')[0].disabled == true)
        $('#select_ano')[0].disabled = false;
    $('#select_mes')[0].disabled = false;
}

function extrair_ano()
{
    select_ano = $('#select_ano')[0]
    return select_ano.value;
}

