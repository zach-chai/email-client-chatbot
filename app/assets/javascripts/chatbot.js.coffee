update_emails_list = (data) ->
  $("#email-list").empty()
  for email in data
    $("#email-list").append "<li class=\"list-group-item\" data-id=\"#{email.id}\">#{email.subject}</li>"

send = ->
   msg = $("#chatbot-message").val()
   $.get "/chatbot/emails?message=#{msg}", (data) ->
      $("#chatbot-messages").append "<li>#{data.msg}</li>"
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
   setupchatbot()
