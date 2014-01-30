//= require jquery.ui.datepicker
//= require jquery.ui.slider
//= require jquery-ui-timepicker-addon

jQuery(function() {
    return $('.datepicker').datetimepicker({
        timeFormat: "hh:mm tt",
        dateFormat: "yy-mm-dd"
    });
});
