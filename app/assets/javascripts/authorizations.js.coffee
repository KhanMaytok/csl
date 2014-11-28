$ ->
  $(document).on 'change', '#first_diagnostic_code', (evt) ->
    $.ajax 'update_diagnostics',
      type: 'GET'
      dataType: 'script'
      data: {
        diagnostic_id: $("#first_diagnostic_code option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")