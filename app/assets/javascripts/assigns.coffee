# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
	$('#remarks').on 'keyup', (ev) ->
	  $('.remarks').val($(ev.currentTarget).val())
	  console.log $('.remarks').val()

