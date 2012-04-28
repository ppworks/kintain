# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'ppworks'
    image 'http://a1.twimg.com/profile_images/1805350696/twitter_icon_20101007_06_normal.png'
    email '90558020@twitter.example.com'
    password 'password'
    providers_users {[
      ProvidersUser.new(
        provider_id: Provider.twitter.id, 
        user_key: "12345",
        access_token: Faker::Lorem.words(1)[0],
        name: 'ppworks'
      )
    ]}
  end
  
  factory :new_user, :class => User do
    name 'ppworks2'
    image 'http://a1.twimg.com/profile_images/1805350696/twitter_icon_20101007_06_normal.png'
    email 'xxx@twitter.example.com'
    password 'password'
  end
end
