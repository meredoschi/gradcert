# This will guess the User class
FactoryBot.define do
  factory :contact do
#    Contact(id: integer, user_id: integer, role_id: integer, termstart: date, termfinish: date, created_at: datetime, updated_at: datetime, name: string, image: string, address_id: integer, phone_id: integer, webinfo_id: integer, personalinfo_id: integer, confirmed: boolean)

#   ************ Associated models - factories to be created ***************
    user
    sequence(:name) {|n| "#{'A'+(n+1000).to_s+Faker::Name.name}" }
#    name NOME+"#{'abcdefghijklm'.split('').shuffle.join.capitalize}"
#    name "Joe Smith"
    address_id 1
    personalinfo_id 1
#    sequence(:name) {|n| "Pessoa #{n+1000}" }
#    sequence(:name) {|n| "#{I18n.t('person').capitalize+' '+(n+1000).to_s}" }

    phone
    webinfo
    role
    trait :admin do
      association :user, :factory => [:user, :admin]
      association :role, :factory => [:role, :itstaff]
    end

    trait :clerical_pap do
      association :user, :factory => [:user, :paplocaladm]
      association :role, :factory => [:role, :clerical, :pap]
    end

    trait :pap_student do
      association :user, :factory => [:user] # student permission
      association :role, :factory => [:role, :student, :pap]
    end

#   ************************************************************************
  end
end
