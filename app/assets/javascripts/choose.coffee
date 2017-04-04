updateButtons = ->
  checkboxes = $( "[data-behavior='genre']" )
  total = checkboxes.length
  checkedCount = checkboxes.filter(":checked" ).length
  $( "[data-behavior='select-none']" ).prop( "disabled", checkedCount == 0 )
  $( "[data-behavior='select-all']" ).prop( "disabled", checkedCount == total )
  $( "[data-behavior='choose']" ).prop( "disabled", checkedCount == 0 )
  if checkedCount == 0
    $( "[data-behavior='choose']" ).prop( "title", "Select some genres!" )
  else
    $( "[data-behavior='choose']" ).prop( "title", "" )

selectAll = ->
  $( "input[type=checkbox]" ).prop( "checked", true )
  $( "input[type=checkbox]" ).parent().addClass( "active" )
  updateButtons()

selectNone = ->
  $( "input[type=checkbox]" ).prop( "checked", false )
  $( "input[type=checkbox]" ).parent().removeClass( "active" )
  updateButtons()

RandBand.pageReady "choose", "chooser", ->
  $( "[data-behavior='genre']:checked" ).parent().addClass( "active" )
  $( "[data-behavior='genre']:not( :checked" ).parent().removeClass( "active" )
  updateButtons()
  $( "[data-behavior='genre']" ).change( updateButtons )
  $( "[data-behavior='select-all']" ).click( selectAll )
  $( "[data-behavior='select-none']" ).click( selectNone )