FactoryGirl.define do
  factory :persona do
    sequence(:name) { Faker::Name.name }
    sequence(:email) { Faker::Internet.email }
  end
end
