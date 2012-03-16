
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
