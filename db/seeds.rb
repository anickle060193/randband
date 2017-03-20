User.create!( username: "test",
              email: "test@test.com",
              password: "testing",
              password_confirmation: "testing",
              admin: true,
              activated: true,
              activated_at: Time.zone.now )

10.times do |n|
  User.create!( username: Faker::Name.name.split().join( '.' ),
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
  Band.from_spotify_band( RSpotify::Artist.search( artist ).first ).save!
end

User.first.like( Band.first )
User.first.like( Band.second )