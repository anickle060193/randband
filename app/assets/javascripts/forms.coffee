$( document ).on "click", "[data-form-submit]", ->
  $( this.getAttribute( "data-form-submit" ) ).submit()