# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

5.times do
User.create(
  name: Faker::Name.name,
  email: Faker::Internet.email,
  password: Faker::Internet.password(8),
  balance: Faker::Number.between(500, 2000)
)

end


User.create(
  name: "frank",
  email: "frank@gmail.com",
  balance: "200",
  password: "12345678",

)
User.create(
  name: "Roberto",
  email: "roberto@gmail.com",
  balance: "500",
  password: "12345678",

)

User.create(
  name: "aaron",
  email: "aaron@gmail.com",
  balance: "1000",
  password: "12345678",
  
)
