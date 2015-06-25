$(document).ready(function(){
	if ($('#pharmacy_unitary')) {
		$('body').on('keypress', '#pharmacy_unitary', function(event) {
			if (event.which == 13) {
				var v_unitary = $(this).val();
				tr = $(this).closest('tr');
				var v_quantity = $('#'+tr.attr('id') + ' #pharmacy_quantity').val();
				id = $(this).closest('tr').attr('id');
				p_id = id.substring(3,id.length);
				$.ajax({url:'/modificarfarmacia',
					type: 'POST',
					data: {
						purchase_insured_pharmacy_id: p_id,
						unitary: v_unitary,
						quantity: v_quantity
					}
				});
			};		
		});	
	};

	if ($('#pharmacy_quantity')) {
		$('body').on('keypress', '#pharmacy_quantity', function(event) {
			if (event.which == 13) {
				var v_quantity = $(this).val();
				tr = $(this).closest('tr');
				var v_unitary = $('#'+tr.attr('id') + ' #pharmacy_unitary').val();
				id = $(this).closest('tr').attr('id');
				p_id = id.substring(3,id.length);
				$.ajax({url:'/modificarfarmacia',
					type: 'POST',
					data: {
						purchase_insured_pharmacy_id: p_id,
						unitary: v_unitary,
						quantity: v_quantity
					}
				});
			};		
		});	
	};
});