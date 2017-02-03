# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  arr = []
  $('.request_id').on 'click', (ev) ->
    arr = $('input:checked').valList()
    console.log $('input:checked').valList()
    $('#request_ids').val(arr)
    @request_list = arr


(($) ->

  $.fn.valList = ->
    $.map(this, (elem) ->
      elem.value or ''
    )

  return
) jQuery
