FactoryBot.define do
  factory :user do
    name { 'Example User' }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    admin { true }
    factory :user_with_microposts do
      after(:create) do |user|
        create(:micropost, user: user)
      end
    end
  end

  factory :other_user, class: User do
    name { "Other User" }
    email { "other@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    admin { false }
  end
end
