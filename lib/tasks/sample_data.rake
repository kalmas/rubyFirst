namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name_pretty: "ExampleUser",
                 email: "example@example.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Internet.user_name + n.to_s
      email = Faker::Internet.email(name)
      password  = "foobar"
      User.create!(name_pretty: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end