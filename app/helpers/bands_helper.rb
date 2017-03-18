module BandsHelper

  def band_link( band )
    provider_band_url( provider: band.provider, provider_id: band.provider_id )
  end

  def edit_band_link( band )
    edit_provider_band_url( provider: band.provider, provider_id: band.provider_id )
  end

end
