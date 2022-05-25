FactoryBot.define do
  factory :comment do
    body { "MyText" }
    board { nil }
    user { nil }
  end
end
