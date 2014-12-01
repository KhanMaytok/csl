$(document).on('change', '#paternal', function(evt) {
    $.ajax('/pacientes/1', {
      type: 'GET',
      dataType: 'script',
      data: {
        paternal: $("#paternal").val(),
        maternal: $("#maternal").val()
      }
    });
});