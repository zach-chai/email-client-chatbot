# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

fetch_emails = ->
  $.get "/emails.json", (data) ->
    for email in data
      $("#email-list").append "<li class=\"list-group-item\">#{email.name}</li>"

setup = ->
  console.log 'setup'

$(document).on 'turbolinks:load', ->
   setup()
   fetch_emails()
