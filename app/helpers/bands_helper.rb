module BandsHelper

  def band_link( band )
    provider_band_url( provider: band.provider, provider_id: band.provider_id )
  end

  def edit_band_link( band )
    edit_provider_band_url( provider: band.provider, provider_id: band.provider_id )
  end

  def band_image_tag( band )
    if @band.thumbnail.present?
      image_tag( @band.thumbnail, alt: @band.name, class: "img-thumbnail band-thumbnail" )
    else
      image_tag( "", alt: @band.name, class: "img-thumbnail band-thumbnail", data: { src: "holder.js/800x600?text=&#63;&size=48&auto=true" } )
    end
  end

  def band_external_link_tag( band )
    if @band.external_url.blank?
      content_tag :h1, @band.name
    else
      content_tag :h1, link_to( @band.name, @band.external_url, target: "_blank", rel: "noopener noreferrer")
    end
  end

end
