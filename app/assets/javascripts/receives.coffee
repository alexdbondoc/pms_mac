# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

x = 0
y = 0
$(document).ready ->
	$('#types').on 'change', (ev) ->
	    if $('#types').val() != 'Please Select'
	      	$('#receive_delivery_type').val($('#types').val())
	      	if $('#types').val() != 'Partial Delivery'
	      		while x < $('.receive_qty').length
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').attr 'disabled': 'disabled'
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').val($('#receive_receive_lines_attributes_' + x + '_qty').val())
	      			$('#remain_qty__' + x + '_').val(0)
	      			$('#rem_qty__' + x + '_').val(0)
	      			console.log x
	      			x++
	      		x = 0
	      	else
	      		while x < $('.receive_qty').length
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').removeAttr('disabled')
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').val(0)
	      			$('#remain_qty__' + x + '_').val($('#receive_receive_lines_attributes_' + x + '_qty').val())
	      			$('#rem_qty__' + x + '_').val($('#receive_receive_lines_attributes_' + x + '_qty').val())
	      			x++
	      		x = 0
	    else
	    	$('#receive_delivery_type').val('')
	    	while x < $('.receive_qty').length
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').disable = false
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').val(0)
	      			$('#remain_qty__' + x + '_').val(0)
	      			$('#rem_qty__' + x + '_').val(0)
	      			x++
	      	x = 0

	$('#type').on 'change', (ev) ->
	    if $('#type').val() != 'Please Select'
	      	$('#receive_delivery_type').val($('#type').val())
	      	if $('#type').val() != 'Partial Delivery'
	      		while x < $('.receive_qty').length
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').attr 'disabled': 'disabled'
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').val($('#po_qty__' + x + '_').val())
	      			$('#remain_qty__' + x + '_').val(0)
	      			$('#rem_qty__' + x + '_').val(0)
	      			console.log x
	      			x++
	      		x = 0
	      	else
	      		while x < $('.receive_qty').length
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').removeAttr('disabled')
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').val(0)
	      			$('#remain_qty__' + x + '_').val($('#po_qty__' + x + '_').val())
	      			$('#rem_qty__' + x + '_').val($('#po_qty__' + x + '_').val())
	      			x++
	      		x = 0
	    else
	    	$('#receive_delivery_type').val('')
	    	while x < $('.receive_qty').length
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').disable = false
	      			$('#receive_receive_lines_attributes_' + x + '_receiving_qty').val(0)
	      			$('#remain_qty__' + x + '_').val(0)
	      			$('#rem_qty__' + x + '_').val(0)
	      			x++
	      	x = 0

	$('.receive_qty').on 'keyup', (ev) ->
	  receive_qty = $(ev.currentTarget).val()
	  count = ev.currentTarget.id.match(/\d+/)[0]
	  qty = $('#receive_receive_lines_attributes_' + count + '_qty').val()
	  remain_qty = qty - receive_qty
	  if remain_qty < 0
	  	$('#remain_qty__' + count + '_').val(remain_qty)
	  	$('#rem_qty__' + count + '_').val(remain_qty)
	  	$('#rem_qty__' + count + '_').css("background-color","#ff0000")
	  else
	  	$('#remain_qty__' + count + '_').val(remain_qty)
	  	$('#rem_qty__' + count + '_').val(remain_qty)
	  	$('#rem_qty__' + count + '_').css("background-color","#ffffff")
	  console.log $('#remain_qty__' + count + '_').val()
