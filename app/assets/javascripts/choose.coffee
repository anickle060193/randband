updateChooseButtons = ->
  checkboxes = $( "[data-behavior*='genre" )
  total = checkboxes.length
  checkedCount = checkboxes.filter( ":checked" ).length
  $( "[data-behavior='choose']" ).prop( "disabled", checkedCount == 0 )
  if checkedCount == 0
    $( "[data-behavior='choose']" ).prop( "title", "Select some genres!" )
  else
    $( "[data-behavior='choose']" ).prop( "title", "" )

updateButtons = ( behavior ) ->
  [ "genre", "genre-group" ].forEach ( behavior ) ->
    checkboxes = $( "[data-behavior='#{behavior}']" )
    total = checkboxes.length
    checkedCount = checkboxes.filter( ":checked" ).length
    $( "[data-behavior='select-none-#{behavior}']" ).prop( "disabled", checkedCount == 0 )
    $( "[data-behavior='select-all-#{behavior}']" ).prop( "disabled", checkedCount == total )
  updateChooseButtons()

makeSelectAll = ( behavior ) ->
  ->
    $( "[data-behavior='#{behavior}']" ).prop( "checked", true )
    $( "[data-behavior='#{behavior}']" ).parent().addClass( "active" )
    updateButtons()

makeSelectNone = ( behavior ) ->
  ->
    $( "[data-behavior='#{behavior}']" ).prop( "checked", false )
    $( "[data-behavior='#{behavior}']" ).parent().removeClass( "active" )
    updateButtons()

RandBand.pageReady "choose", "chooser", ->
  $( "[data-behavior*='genre']:checked" ).parent().addClass( "active" )
  $( "[data-behavior*='genre']:not( :checked" ).parent().removeClass( "active" )
  updateButtons()
  $( "[data-behavior*='genre']" ).change( updateButtons )
  $( "[data-behavior='select-all-genre']" ).click( makeSelectAll( 'genre' ) )
  $( "[data-behavior='select-none-genre']" ).click( makeSelectNone( 'genre' ) )
  $( "[data-behavior='select-all-genre-group']" ).click( makeSelectAll( 'genre-group' ) )
  $( "[data-behavior='select-none-genre-group']" ).click( makeSelectNone( 'genre-group' ) )