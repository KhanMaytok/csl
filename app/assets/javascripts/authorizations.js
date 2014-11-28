$(document).on('change', '#first_diagnostic_code', function(evt) {  
  $.ajax('/update_diagnostics', {
    type: 'GET',
    dataType: 'script',
    data: {
      first_diagnostic_id: $("#first_diagnostic_code option:selected").val(),
      second_diagnostic_id: $("#second_diagnostic_code option:selected").val(),
      third_diagnostic_id: $("#third_diagnostic_code option:selected").val()
    }
  });
});

$(document).on('change', '#second_diagnostic_code', function(evt) {
  $.ajax('/update_diagnostics', {
    type: 'GET',
    dataType: 'script',
    data: {
      first_diagnostic_id: $("#first_diagnostic_code option:selected").val(),
      second_diagnostic_id: $("#second_diagnostic_code option:selected").val(),
      third_diagnostic_id: $("#third_diagnostic_code option:selected").val()
    }
  });
});

$(document).on('change', '#third_diagnostic_code', function(evt) {
  $.ajax('/update_diagnostics', {
    type: 'GET',
    dataType: 'script',
    data: {
      first_diagnostic_id: $("#first_diagnostic_code option:selected").val(),
      second_diagnostic_id: $("#second_diagnostic_code option:selected").val(),
      third_diagnostic_id: $("#third_diagnostic_code option:selected").val()
    }
  });
});
