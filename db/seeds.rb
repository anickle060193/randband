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