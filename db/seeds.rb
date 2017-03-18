User.create!( name: "Tester McFirst",
              email: "test@test.com",
              password: "testing",
              password_confirmation: "testing",
              admin: true,
              activated: true,
              activated_at: Time.zone.now )

10.times do |n|
  name = Faker::Name.name
  email = "test#{n+1}@test.com"
  password = "testing"
  User.create!( name: name,
                email: email,
                password: password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now )
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