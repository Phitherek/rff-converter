# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ = jQuery

initialize_things = =>
    $(".formbox").find('input[type="submit"]').click ->
        $(".formbox").find(".upload_message").html("Please wait, your upload is in progress, this may take a while...")

initialize_intervals = =>
    if $("#afterconversion_form").length > 0
        @current_key = $("#afterconversion_form").data("key")
        @int1 = setInterval(update_conversion_status, 1000)
    @int2 = setInterval(update_stats, 10000)
        
afterconversion_submit = =>
    $("#afterconversion_form").submit()

update_conversion_status = =>
    $.get(["/", @current_key, ".json"].join(""), (data) =>
        if data[0] == "processing" || data[0] == "new"
            $(".conversion.pbcontainer .bar").css("width", data[1] + "%")
            $(".conversion.pbcontainer .progress_percentage").html(data[1] + "%")
        else
            clearInterval(@int1)
            afterconversion_submit()
    )

update_stats = =>
    $.get("/stats.json", (data) =>
        $("#processing_count").html(data[0])
        $("#available_disk_space").html(data[1])
    )

$(document).ready ->
    initialize_things()
    initialize_intervals()
$(document).on("page:load", ->
    initialize_things()
)
$(document).ajaxComplete ->
    initialize_things()
