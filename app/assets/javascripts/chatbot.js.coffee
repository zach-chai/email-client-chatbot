setupchatbot = ->
   $("#chatbot-submit").click ->
      msg = $("#chatbot-message").val()
      $.get "/chatbot?message=#{msg}", (data) ->
         $("#message-list").append "<li>#{data.message}</li>"

$(document).on 'turbolinks:load', ->
   setupchatbot()
