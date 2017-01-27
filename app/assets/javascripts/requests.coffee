# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  add_row = (table_body_element) ->
    $cloner = undefined
    $new_row = undefined
    $rows = undefined
    $tbody = undefined
    count = undefined
    inputs = undefined

    $tbody = $('#' + table_body_element)
    $rows = $($tbody.children('tr'))
    $cloner = $rows.eq(0)
    count = $rows.length

    $new_row = $cloner.clone()
    inputs = $new_row.find('.dyn-input')

    console.log inputs
    $.each inputs, (i, v) ->
      
      $input = $(v)
      $label = $new_row.find("label[for='#{$input.attr('id')}']")
      $label.attr( {'for': $input.attr('id').replace(/\[.*\]/, "[#{count + 1}]")} )

      
      console.log "counting" + count
      $input.val ''
      checked = $input.prop('checked')
      if checked
          return $input.prop('checked', false)
      return

    $tbody.append $new_row

  $('#add-row').on 'click', (ev) ->
    ev.preventDefault()
    table_body = $(ev.target).data().table
    if table_body
      return add_row(table_body)

  $('#submit').on 'click', (ev) ->
    console.log "asd"


