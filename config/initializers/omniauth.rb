require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, Rails.application.secrets.spotify_id, Rails.application.secrets.spotify_secret, scope: 'user-follow-read'
end