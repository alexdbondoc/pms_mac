# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

x = undefined
amount = undefined
qty = undefined
price = undefined 
count = undefined

$(document).ready ->
  arr = []
  $('.ords_id').on 'click', (ev) ->
    arr = $('input:checked').valList()
    $('#ords_ids').val(arr)
    console.log arr

  (($) ->

    $.fn.valList = ->
      $.map(this, (elem) ->
        elem.value or ''
      )

    return
  ) jQuery

  $('#order_supplier_id').on 'change', (ev) ->
    if $(ev.currentTarget).val() == ""
      $('#address').val("")
      $('#tel').val("")
      $('#fax').val("")
      $('#tin').val("")
      $('#person').val("")
      $('#email').val("")
    else
      x = $(ev.currentTarget).val() - 1
      arr = $('.supplier_info').data('supp')
      $('#address').val(arr[x]['address'])
      $('#tel').val(arr[x]['tel'])
      $('#fax').val(arr[x]['fax'])
      $('#tin').val(arr[x]['tin'])
      $('#person').val(arr[x]['representative'])
      $('#email').val(arr[x]['email'])
      console.log arr[x]

  $('.unit_price').on 'keyup', (ev) ->
    price = $(ev.currentTarget).val()
    count = ev.currentTarget.id.match(/\d+/)[0]
    qty = $('#order_order_lines_attributes_' + count + '_qty').val()
    amount = qty * price
    $('#order_order_lines_attributes_' + count + '_amount').val(parseFloat(Math.round(amount * 100) / 100).toFixed(2))
    y = 0
    total_amount = 0
    while y < $('.unit_price').length
      if $('#order_order_lines_attributes_' + y + '_amount').val() > 0
        total_amount = parseInt(total_amount) + parseInt($('#order_order_lines_attributes_' + y + '_amount').val())
      y++
    $('.total_amount').val(parseFloat(Math.round(total_amount * 100) / 100).toFixed(2))
    console.log parseFloat(Math.round(total_amount * 100) / 100).toFixed(2)