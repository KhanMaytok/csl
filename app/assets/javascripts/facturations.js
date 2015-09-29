$(document).ready(function(){
	$(".check_box").change(function(){
		if( $(this).is(':checked') ){
			$.ajax({
				method: "POST",
				url: "/facturas/get_checked",
				data: { pay_document_id: $(this).attr('id')}
			})
		}
		else
		{
			$.ajax({
				method: "POST",
				url: "/facturas/get_unchecked",
				data: { pay_document_id: $(this).attr('id')}
			})
		}
	});
})
