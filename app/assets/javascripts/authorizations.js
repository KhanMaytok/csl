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
$(document).ready(function(){
  if ($('#status_id')) {
    $('body').on('change', '#status_id', function(event) {
      tr = $(this).closest('tr');
      var authorization = $('#'+tr.attr('id') + ' #authorization_id').val();      
      var status = $(this).val();
      var page_inf = $('#page').val();
      $.ajax({url:'/modificar_estado',
        type: 'POST',
        data: { 
          status_id : status,
          authorization_id : authorization,
          page : page_inf
        }
      });
    })
  };
});
