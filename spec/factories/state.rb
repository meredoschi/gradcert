# This will guess the User class
FactoryBot.define do
  factory :state do
    # http://stackoverflow.com/questions/3482149/how-do-i-pick-randomly-from-an-array
   random_num=Random.rand(100)
   abbreviation "TE"
   state_name=Faker::Address.state+' '+random_num.to_s.capitalize
   country
   name "#{state_name}"
  end
end
