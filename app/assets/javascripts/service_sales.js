$(document).ready(function(){
	$('#code_id').on('change', function(event) {
	  var selected_resource_id = $(this).val();
	  $.ajax({url:'/cambiarcodigonombre',
	  	type: 'POST',
	  		 data: { id : selected_resource_id }})
	});
});
