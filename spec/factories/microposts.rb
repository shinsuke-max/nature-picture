FactoryBot.define do
  factory :micropost do
    content { "MyText" }
    user_id { user.id }
  end

  factory :microposts, class: Micropost do
    trait :micropost1 do
      content { "TT" }
      user_id { 1 }
      created_at { 5.minutes.ago }
    end

    trait :micropost2 do
      content { "PP" }
      user_id { 1 }
      created_at { 5.hours.ago }
    end

    trait :micropost3 do
      content { "QQ" }
      user_id { 1 }
      created_at { Time.zone.now }
    end
    association :user, factory: :user
  end
end
