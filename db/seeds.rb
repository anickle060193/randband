User.transaction do
  User.create!( username: "test",
                email: "test@test.com",
                password: "testing",
                password_confirmation: "testing",
                admin: true,
                activated: true,
                activated_at: Time.zone.now )

  10.times do |n|
    User.create!( username: Faker::Name.name.gsub( /[^0-9a-z]/i, '' ),
                  password: "testing",
                  password_confirmation: "testing" )
  end

  artists = [
    "Lindsey Stirling",
    "Taylor Swift",
    "Ryn Weaver",
    "My Chemical Romance",
    "Fall Out Boy"
    ]

  artists.each do |artist|
    Band.find_or_create_from_spotify_band( RSpotify::Artist.search( artist ).first )
  end

  User.first.like( Band.first )
  User.first.like( Band.second )
end