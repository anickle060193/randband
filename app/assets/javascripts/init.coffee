window.App ||= { }

App.init = ->
  $( "a, span, i, div" ).tooltip()

App.ready = ( callback ) ->
  $( document ).on( "turbolinks:load", callback )

App.pageReady = ( controller, action, callback ) ->
  App.ready ->
    selector = "[data-controller='#{controller}'][data-action='#{action}']"
    callback() if $( selector ).length > 0

App.ready ->
  App.init()