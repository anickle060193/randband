module BandsHelper

  def band_link( band )
    provider_band_url( provider: band.provider, provider_id: band.provider_id )
  end

end
