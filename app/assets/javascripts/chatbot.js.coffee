send = ->
   msg = $("#chatbot-message").val()
   $.get "/chatbot?message=#{msg}", (data) ->
      $("#message-list").append "<li>#{data.message}</li>"

setupchatbot = ->
   $("#chatbot-submit").click ->
      send()
   $("#chatbot-message").keypress (ev) ->
    if ev.which == 13
      send()

$(document).on 'turbolinks:load', ->
   setupchatbot()
