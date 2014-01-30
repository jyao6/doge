//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl

jQuery(function() {
    $('#photo_img').attr('name', 'photo[img]');
    return $('#new_photo').fileupload({
        dataType: 'script',
        add: function(e, data) {
            var file, types;
            types = /(\.|\/)(gif|jpe?g|png)$/i;
            file = data.files[0];
            if (types.test(file.type) || types.test(file.name)) {
                data.context = $(tmpl("template-upload", file));
                $('#new_photo').append(data.context);
                return data.submit();
            } else {
                return alert("" + file.name + " is not a gif, jpg or png image file");
            }
        },
        progress: function(e, data) {
            var progress;
            if (data.context) {
                progress = parseInt(data.loaded / data.total * 100, 10);
                return data.context.find('.progress-bar').css('width', progress + '%');
            }
        }
    });
});
