FactoryBot.define do
  factory :taxation do
    # Taxation(id: integer, socialsecurity: decimal, bracket_id: integer, name: string, start: date, finish: date, pap: boolean, medres: boolean)
    two_years_ago=Date.today-2.years
    in_a_year=Date.today+1.year

    start "#{two_years_ago}"
    finish "#{in_a_year}"
    pap true
    name "Brazilian taxes"
    socialsecurity 11

    trait :personal do


      before(:create) do |taxation|
        initial_bracket = FactoryBot.create(:bracket, :initial)
        second_bracket = FactoryBot.create(:bracket, :second)
        third_bracket = FactoryBot.create(:bracket, :third)
        fourth_bracket = FactoryBot.create(:bracket, :fourth)

        taxation.brackets << initial_bracket
        taxation.brackets << second_bracket
        taxation.brackets << third_bracket
        taxation.brackets << fourth_bracket

      end

    end




  end
end
