# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :posts_provider do
    post_id 1
    post_key "MyString"
    content "MyString"
  end
end
