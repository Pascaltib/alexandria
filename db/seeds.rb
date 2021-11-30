puts "Clearing database..."
Booking.delete_all
Cost.delete_all
Batch.delete_all
User.delete_all

puts "Creating seeds...."

test_user = User.create!(
  {
    email: "admin@gmail.com",
    password: "password",
    first_name: "Admin",
    last_name: "Admin",
    admin: true
  }
)

test_batch = Batch.create!(user: test_user, name: "Madrid", tuition_cost: 6500, start_date: "Mon, 29 Nov 2021", end_date: "Fri, 10 Dec 2021")
count = 10
11.times do
  temp = URI.open("https://cdn.devdojo.com/images/june2021/avt-#{count}.jpg")
  student = User.create!(
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "password",
      admin: false
    }
  )
  student.photo.attach(io: temp, filename: "nes.jpg", content_type: "image/jpg")
  if count < 15
    Booking.create!(user: student, batch: test_batch)
  else
    Booking.create!(user: student, batch: test_batch, status: "Accepted")
  end
  count += 1
end

Cost.create!(name: "Rent", amount: 50_000, kind: "Fixed", batch: test_batch, recurring: "Yearly")
Cost.create!(name: "Teacher Salary", amount: 5000, kind: "Fixed", batch: test_batch, recurring: "Monthly")
Cost.create!(name: "Food", amount: 200, kind: "Variable", batch: test_batch, recurring: "One Time")
Cost.create!(name: "Drinks", amount: 100, kind: "Variable", batch: test_batch, recurring: "One Time")
Cost.create!(name: "Chairs", amount: 200, kind: "Variable", batch: test_batch, recurring: "One Time")
Cost.create!(name: "Tables", amount: 250, kind: "Variable", batch: test_batch, recurring: "One Time")

puts "Database created!"
