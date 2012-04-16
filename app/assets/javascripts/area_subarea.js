$(document).ready(function() {
    $("#area").change(function() {
        var id = this.value;
        $.post("/areas/" + id + "/sub_areas");
    });
});
