window.RandBand ||= { }

RandBand.init = ->
  salvattore.init()
  Holder.run()

RandBand.ready = ( callback ) ->
  $( document ).on( "turbolinks:load", callback )

RandBand.pageReady = ( controller, action, callback ) ->
  RandBand.ready ->
    selector = "[data-controller='#{controller}'][data-action='#{action}']"
    callback() if $( selector ).length > 0

RandBand.ready ->
  RandBand.init()