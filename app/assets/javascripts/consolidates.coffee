# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  arr = []
  $('.cons_id').on 'click', (ev) ->
    arr = $('input:checked').valList()
    console.log $('input:checked').valList()
    $('#cons_ids').val(arr)


(($) ->

  $.fn.valList = ->
    $.map(this, (elem) ->
      elem.value or ''
    )

  return
) jQuery