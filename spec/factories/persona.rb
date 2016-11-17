FactoryGirl.define do
  factory :persona do
    sequence(:name) {|n| Faker::Name.name}
    sequence(:email) {|n| Faker::Internet.email}
  end
end
