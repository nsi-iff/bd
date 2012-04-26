$(document).ready(function() {
    $("#select_instituicao").change(function() {
        var id = this.value;
        $.post("/instituicoes/" + id + "/campus");
    });
});
