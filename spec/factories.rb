FactoryGirl.define do
  factory :user do
    sequence(:name_pretty)  { |n| "Person_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
  end
end