RandBand.pageReady "choose", "chooser", ->
  RandBand.selector.addOnChange ( selected, totalSelected, totalUnselected ) ->
    if totalSelected == 0
      $( "[data-behavior='choose']" ).prop( "disabled", true )
      $( "[data-behavior='choose']" ).prop( "title", "Select some genres!" )
    else
      $( "[data-behavior='choose']" ).prop( "disabled", false )
      $( "[data-behavior='choose']" ).prop( "title", "" )