RandBand.selector ||= { }

updateButtons = ( select ) ->
  checkboxes = $( "[data-select='#{select}']" )
  total = checkboxes.length
  checkedCount = checkboxes.filter( ":checked" ).length
  $( "[data-selector='none'][data-selector-select='#{select}']" ).prop( "disabled", checkedCount == 0 )
  $( "[data-selector='all'][data-selector-select='#{select}']" ).prop( "disabled", checkedCount == total )

makeSelectAll = ( select ) ->
  ->
    $( "[data-select='#{select}']" ).prop( "checked", true )
    $( "[data-select='#{select}']" ).parent().addClass( "active" )
    updateButtons( select )

makeSelectNone = ( select ) ->
  ->
    $( "[data-select='#{select}']" ).prop( "checked", false )
    $( "[data-select='#{select}']" ).parent().removeClass( "active" )
    updateButtons( select )

makers = {
  "all": makeSelectAll,
  "none" : makeSelectNone
}

makeOnChange = ( callback ) ->
  ->
    selected = { }
    totalSelected = 0
    totalUnselected = 0
    $( "[data-select]" ).each ->
      selected[ this.dataset.select ] ||= { checked: 0, unchecked: 0 }
      if this.checked
        selected[ this.dataset.select ].checked++
        totalSelected++
      else
        selected[ this.dataset.select ].unchecked++
        totalUnselected++
    callback( selected, totalSelected, totalUnselected )

RandBand.selector.init = ->
  $( "[data-select]:checked" ).parent().addClass( "active" )
  $( "[data-select]:not( :checked" ).parent().removeClass( "active" )

  $( "[data-selector]" ).each ->
    selector = this.dataset.selector
    if selector not of makers
      throw "Invalid Selector Type: #{selector} - Must be one of '#{Object.keys( makers ).join( "', '" )}'."

    select = this.dataset.selectorSelect
    updateButtons( select )
    $( this ).click( makers[ selector ]( select ) )
    $( "[data-select='#{select}']" ).change ->
      updateButtons( select )

RandBand.selector.addOnChange = ( callback ) ->
  onChange = makeOnChange( callback )
  onChange()
  $( "[data-select]" ).change( onChange )
  $( "[data-selector]" ).click( onChange )

RandBand.ready ->
  RandBand.selector.init()