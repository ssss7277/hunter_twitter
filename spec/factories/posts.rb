FactoryBot.define do
  factory :post do
    body { "はんたーはんたー" }
    association :user
    # body { "MyText" }
    # user_id { 1 }
  end
end
