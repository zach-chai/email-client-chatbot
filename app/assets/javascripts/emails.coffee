# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# fetch_emails = ->
#   $.get "/emails.json", (data) ->
#     for email in data
#       $("#email-list").append "<li class=\"list-group-item\" data-id=\"#{email.id}\">#{email.subject}</li>"
#
# setup = ->
#   console.log 'setup'
#   $("#email-list").on 'click', '.list-group-item', ->
#     $("#email-list .selected").removeClass('selected')
#     id = $(this).data 'id'
#     that = $(this)
#     $.get "/emails/#{id}.json", (data) ->
#       $("#email-sender").html "#{data.sender}"
#       $("#email-subject").html "#{data.subject}"
#       $("#email-body").html "#{data.body}"
#       that.addClass('selected')
#       # $("#email-wrapper").html "
#       #   <div class='sender'>
#       #     #{data.sender}
#       #   </div>
#       #   <div class='subject'>
#       #     #{data.subject}
#       #   </div>
#       #   <div class='body'>
#       #     #{data.body}
#       #   </div>"
#
#
# $(document).on 'turbolinks:load', ->
#    setup()
#    fetch_emails()
