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


user_1 = User.create(
  name: "frank",
  email: "frank@gmail.com",
  balance: "20000",
  password: "12345678",

)
user_2 = User.create(
  name: "Roberto",
  email: "roberto@gmail.com",
  balance: "5000",
  password: "12345678",

)

user_3 = User.create(
  name: "aaron",
  email: "aaron@gmail.com",
  balance: "10000",
  password: "12345678",
)

user_4 = User.create(
  name: "cori",
  email: "cori@gmail.com",
  balance: "20000",
  password: "12345678",
)

user_5 = User.create(
  name: "Nick",
  email: "nick@gmail.com",
  balance: "7000",
  password: "12345678",
)

user_6 = User.create(
  name: "Burke",
  email: "burke@gmail.com",
  balance: "6000",
  password: "12345678",
)

Transaction.create(lender_id: user_1.id, borrower_id: user_2.id, amount: 10)
Transaction.create(lender_id: user_1.id, borrower_id: user_4.id, amount: 5)
Transaction.create(lender_id: user_2.id, borrower_id: user_3.id, amount: 5)
Transaction.create(lender_id: user_1.id, borrower_id: user_5.id, amount: 5)
Transaction.create(lender_id: user_2.id, borrower_id: user_4.id, amount: 5)
Transaction.create(lender_id: user_4.id, borrower_id: user_1.id, amount: 15)
Transaction.create(lender_id: user_3.id, borrower_id: user_6.id, amount: 15)
Transaction.create(lender_id: user_6.id, borrower_id: user_1.id, amount: 15)

Friendship.create(user_id: user_1, friend_id: user_2)
Friendship.create(user_id: user_1, friend_id: user_3)
Friendship.create(user_id: user_1, friend_id: user_4)
Friendship.create(user_id: user_1, friend_id: user_5)
Friendship.create(user_id: user_2, friend_id: user_5)
Friendship.create(user_id: user_2, friend_id: user_4)
Friendship.create(user_id: user_2, friend_id: user_3)
Friendship.create(user_id: user_3, friend_id: user_4)
Friendship.create(user_id: user_3, friend_id: user_5)
