updateShortcutButtons = ->
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
  updateShortcutButtons()

selectNone = ->
  $( "input[type=checkbox]" ).prop( "checked", false )
  $( "input[type=checkbox]" ).parent().removeClass( "active" )
  updateShortcutButtons()

App.pageReady "choose", "chooser", ->
  updateShortcutButtons()
  $( "[data-behavior='genre']" ).change( updateShortcutButtons )
  $( "[data-behavior='select-all']" ).click( selectAll )
  $( "[data-behavior='select-none']" ).click( selectNone )
