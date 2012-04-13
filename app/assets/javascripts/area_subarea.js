//TODO: refatorar / melhorar (2012-04-12, 17:39, ciberglo)`
$(document).ready(function() {

    $("#area").change(function() {
        var id = this.value;
        $.post("/areas/" + id + "/sub_areas");
    });
});
