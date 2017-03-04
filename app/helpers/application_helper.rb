module ApplicationHelper

  def full_title( page_title='' )
    base_title = "RandBand"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def navbar_link_item( s, link )
    content_tag( :li, link_to( s, link ), class: ( "active" if current_page?( link ) ) )
  end

end
