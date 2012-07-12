$(document).ready(function() {
    $("#area").change(function() {
        var id = this.value;
        if (id != 'Todas')
          $.post("/areas/" + id + "/sub_areas");
        else
        {
          var sub_areas = $(".sub_areas");
          sub_areas.children().remove();
          sub_areas.append("<option>Todas</option>");
        }
    });
});
