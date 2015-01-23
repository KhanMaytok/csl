$(document).ready(function(){
	if ($('#clinic_area_id')) {
		$('body').on('change', '#clinic_area_id', function(event) {
			var selected_resource_id = $(this).val();
			$.ajax({url:'/cambiarservicioselect',
				type: 'POST',
				data: { clinic_area_id : selected_resource_id }
			});
		});
	};
	
	if ($('#service_id')) {
		$('body').on('change', '#service_id', function(event) {}).on('keypress', '#service_id', function(event) {
			if (event.which == 13) {
				var selected_resource_id = $(this).val();
				var authorization = $('#authorization_id').val();
				$.ajax({url:'/cambiarunitariotext',
					type: 'POST',
					data: { 
						service_id : selected_resource_id,
						authorization_id : authorization
					}
				});
				$.ajax({url:'/cambiarcodigoservicios',
					type: 'POST',
					data: { service_id : selected_resource_id }
				});
			};			
		});
	};

	
	if ($('#code_id')) {
		$('body').on('change', '#code_id', function(event) {
			$('body').on('click', '#code_id', function(event) {
				var selected_resource_id = $(this).val();
				$.ajax({url:'/cambiarunitariotext',
					type: 'POST',
					data: { service_id : selected_resource_id }
				});
				$.ajax({url:'/cambiarnombreservicios',
					type: 'POST',
					data: { service_id : selected_resource_id }
				});
			});			
		});
	};

	if ($('#p_doctor_id')) {
		$('body').on('change', '#p_doctor_id', function(event) {
			var doctor = $(this).val();
			tr = $(this).closest('tr');
			var v_unitary = $('#'+tr.attr('id') + ' #p_unitary').val();
			var v_quantity = $('#'+tr.attr('id') + ' #p_quantity').val();
			id = $(this).closest('tr').attr('id');
			p_id = id.substring(3,id.length);
			$.ajax({url:'/update_all_purchase',
				type: 'POST',
				data: {
					purchase_insured_service_id: p_id,
					doctor_id : doctor,
					unitary: v_unitary,
					quantity: v_quantity
				}
			});
		});	
	};

	if ($('#p_unitary')) {
		$('body').on('keypress', '#p_unitary', function(event) {
			if (event.which == 13) {
				$(this).focus();
				var v_unitary = $(this).val();
				tr = $(this).closest('tr');
				var doctor = $('#'+tr.attr('id') + ' #p_doctor_id').val();
				var v_quantity = $('#'+tr.attr('id') + ' #p_quantity').val();
				id = $(this).closest('tr').attr('id');
				p_id = id.substring(3,id.length);
				$(this).focus();
				$.ajax({url:'/update_all_purchase',
					type: 'POST',
					data: {
						purchase_insured_service_id: p_id,
						doctor_id : doctor,
						unitary: v_unitary,
						quantity: v_quantity
					}
				});
			};		
		});	
	};

	if ($('#p_quantity')) {
		$('body').on('keypress', '#p_quantity', function(event) {
			if (event.which == 13) {
				$(this).focus();
				var v_quantity = $(this).val();
				tr = $(this).closest('tr');
				var doctor = $('#'+tr.attr('id') + ' #p_doctor_id').val();
				var v_unitary = $('#'+tr.attr('id') + ' #p_unitary').val();
				id = $(this).closest('tr').attr('id');
				p_id = id.substring(3,id.length);
				$(this).focus();
				$.ajax({url:'/update_all_purchase',
					type: 'POST',
					data: {
						purchase_insured_service_id: p_id,
						doctor_id : doctor,
						unitary: v_unitary,
						quantity: v_quantity
					}
				});
			};
		});	
	};
});

