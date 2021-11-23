# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Clearing database..."
Booking.delete_all
Cost.delete_all
Batch.delete_all
User.delete_all

puts "Creating seeds...."

User.create!(
  {
    email: "admin@gmail.com",
    password: "password",
    first_name: "Admin",
    last_name: "Admin",
    admin: true
  }
)
count = 10
11.times do
  User.create!(
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "password",
      admin: false,
      image_url: "https://cdn.devdojo.com/images/june2021/avt-#{count}.jpg"
    }
  )
  count += 1
end

puts "Database created!"
