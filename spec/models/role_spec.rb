# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  # Constant
  let(:types) { %i[management teaching clerical collaborator student itstaff] }

  let(:role) { FactoryBot.create(:role) }

  let(:pap_student) { FactoryBot.create(:role, :student, :pap) }

  let(:inconsistent_role) { FactoryBot.create(:role, :clerical_and_it) }

  context 'When a type is not selected' do
    it '-creation is blocked if no type is not specified' do
      expect do
        sample_role = FactoryBot.create(:role)
        print 'Number of types: '
        puts sample_role.num_types_selected
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'Multiple role types selected' do
    it '-creation is blocked if two types are selected' do
      expect do
        FactoryBot.create(:role, :clerical_and_it)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  it '-types_selected' do
    role.clerical = true
    role.itstaff = true
    role_types_selected = []

    types.each do |t|
      role_types_selected << t if role.send(t)
    end

    print 'Role types selected: '
    puts role_types_selected.count.to_s
    puts role_types_selected

    expect(role_types_selected).to eq role.types_selected
  end

  it 'can be created' do
    print I18n.t('activerecord.models.role').capitalize + ': '
    FactoryBot.create(:role)
  end

  it 'clerical (clerical) can be created' do
    print I18n.t('activerecord.models.role').capitalize + ': '
    FactoryBot.create(:role, :clerical)
  end

  # i.e. True
  # https://stackoverflow.com/questions/621176/how-to-dynamically-call-accessor-methods-in-ruby
  it '-num_types_selected' do
    role_num_types_selected = role.types_selected.count

    expect(role_num_types_selected).to eq role.num_types_selected
  end

  it '-exactly_one_type_selected?' do
    situation = (role.num_types_selected == 1)
    expect(situation).to eq role.exactly_one_type_selected?
  end
end
