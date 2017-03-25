RandBand.ready ->
  $( "a.band-tab" ).click ->
    url = new Url()
    url.query.provider = this.getAttribute( "data-provider" )
    history.replaceState( null, null, url.toString() )