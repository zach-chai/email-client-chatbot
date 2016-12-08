update_emails_list = (data) ->
  $("#email-list").empty()
  for email in data
    $("#email-list").append "<li class=\"list-group-item\" data-id=\"#{email.id}\">#{email.subject}</li>"

fetch_emails = ->
  $.get "/emails.json", (data) ->
    for email in data
      $("#email-list").append "<li class=\"list-group-item\" data-id=\"#{email.id}\">#{email.subject}</li>"

setup = ->
  console.log 'setup'
  $("#email-list").on 'click', '.list-group-item', ->
    $("#email-list .selected").removeClass('selected')
    id = $(this).data 'id'
    that = $(this)
    $.get "/emails/#{id}.json", (data) ->
      $("#email-sender").html "#{data.sender}"
      $("#email-subject").html "#{data.subject}"
      $("#email-body").html "#{data.body}"
      that.addClass('selected')
      # $("#email-wrapper").html "
      #   <div class='sender'>
      #     #{data.sender}
      #   </div>
      #   <div class='subject'>
      #     #{data.subject}
      #   </div>
      #   <div class='body'>
      #     #{data.body}
      #   </div>"

send = ->
   msg = $("#chatbot-message").val()
   $("#chatbot-messages").append "<li>You : #{msg}</li>"
   $.post "/chatbot/message", {message: msg}, (data) ->
      $("#chatbot-messages .placeholder").remove();
      $("#chatbot-messages").append "<li>EmailBot : #{data.msg}</li>"
      if data.suggestion
        $("#chatbot-message").val(data.suggestion)
      if data.emails
        update_emails_list(data.emails)

clearChat = ->
   $("#chatbot-message").val ''

setupchatbot = ->
   $("#chatbot-submit").click ->
      send()
      clearChat()
   $("#chatbot-message").keypress (ev) ->
    if ev.which == 13
      send()
      clearChat()

$(document).on 'turbolinks:load', ->
   setup()
   fetch_emails()
   setupchatbot()
