# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ = jQuery

initialize_things = ->
    $(".formbox").find('input[type="submit"]').click ->
        $(".formbox").find(".upload_message").html("Please wait, your upload is in progress, this may take a while...")

$(document).ready ->
    initialize_things()
$(document).on("page:load", ->
    initialize_things()
)
$(document).ajaxComplete ->
    initialize_things()
