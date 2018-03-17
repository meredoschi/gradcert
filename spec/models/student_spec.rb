require 'rails_helper'

RSpec.describe Student, type: :model do
  # let(:student) { FactoryBot.create(:student) }

  #  pending "add some examples to (or delete) #{__FILE__}"

  # https://stackoverflow.com/questions/30927459/rspec-validation-failed-name-has-already-been-taken
  #  let(:user) { FactoryBot.create(:user) }

  let(:student) { FactoryBot.create(:student) }

  it { is_expected.to have_many(:annualstatement) }

  it 'can be created (PAP)' do
    FactoryBot.create(:student)
  end

  it '-name_birth_tin' do
    student_name_birth_tin = student.contact.name_birth_tin

    expect(student_name_birth_tin).to eq(student.name_birth_tin)
  end

  it '-reimbursed?' do
    student_reimbursement_existence = student.reimbursements.exists?

    expect(student_reimbursement_existence).to eq student.reimbursed?
  end

  it '#with_annual_statements' do
    students_with_annual_statements = Student.joins(:annualstatement)

    expect(students_with_annual_statements).to eq Student.with_annual_statements
  end
end
