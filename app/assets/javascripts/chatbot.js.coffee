send = ->
   msg = $("#chatbot-message").val()
   $.get "/chatbot?message=#{msg}", (data) ->
      $("#message-list").append "<li>#{data.message}</li>"

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
