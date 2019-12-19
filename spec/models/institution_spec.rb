# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Institution, type: :model do
  let(:sample_payroll) { FactoryBot.create(:payroll, :personal_taxation) } # Monthly payroll
  let(:institution) { FactoryBot.create(:institution) }
  let(:sample_schoolterm) { FactoryBot.create(:schoolterm) }
  let(:placesavailable)  { FactoryBot.create(:placesavailable) }

  context 'Associations' do
    it { is_expected.to belong_to(:institutiontype) }

    it { is_expected.to have_many(:characteristic) }
    it { is_expected.to have_many(:college) }
    it { is_expected.to have_many(:healthcareinfo) }
    it { is_expected.to have_many(:placesavailable) }
    it { is_expected.to have_many(:researchcenter) }
    it { is_expected.to have_many(:roster) }
    it { is_expected.to have_many(:user).dependent(:restrict_with_exception) }

    it { is_expected.to have_one(:accreditation) }
    it { is_expected.to accept_nested_attributes_for(:accreditation) }

    it { is_expected.to have_one(:address) }
    it { is_expected.to accept_nested_attributes_for(:address) }

    it { is_expected.to have_one(:phone) }
    it { is_expected.to accept_nested_attributes_for(:phone) }

    it { is_expected.to have_one(:webinfo) }
    it { is_expected.to accept_nested_attributes_for(:webinfo) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:institutiontype_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_most(250) }
    it { is_expected.to validate_length_of(:abbreviation).is_at_most(20) }

    it 'abbreviation may not contain special characters (except underscore)' do
      expect { FactoryBot.create(:institution, :special_characters_in_the_abbreviation) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'Class methods' do
    # Institutions with registrations (active or otherwise)
    it '#with_registrations' do
      institutions_with_registrations = Institution.where(id: Registration.institution_ids)

      expect(institutions_with_registrations).to eq Institution.with_registrations
    end

    # This method returns institution_ids (rather than institution objects)
    it '#annotated_on_payroll(sample_payroll)' do
      payroll_registrations = Registration.regular_within_payroll_context(sample_payroll)
                                          .joins(student: [contact: { user: :institution }])
                                          .joins(:annotation)

      institution_ids = payroll_registrations.pluck('institutions.id').uniq.sort

      expect(institution_ids).to eq(Institution.annotated_on_payroll(sample_payroll))
    end

    it '#with_contacts' do
      institutions_with_contacts = Institution.joins(user: :contact).uniq.order(:name)
      expect(institutions_with_contacts).to eq(Institution.with_contacts)
    end
  end

  context 'Instance methods' do

    it 'can be created' do
      FactoryBot.create(:institution)
    end

    # New for 2017
    it '-abbrv' do
      max_len = Settings.max_length_for_institution_abbreviation # default is 65

      institution_abbrv = if institution.abbreviation.present?

                            institution.abbreviation.upcase

                          else

                            Pretty.initialcaps(institution.name[0..max_len])

                          end

      expect(institution_abbrv).to eq(institution.abbrv)
    end

    # Returns an active record relation
    it '-schoolterm_enrollment_list(sample_schoolterm)' do
      enrollment_list_for_the_school_term = Registration.on_schoolterm(sample_schoolterm)
                                                        .from_institution(institution)
      expect(enrollment_list_for_the_school_term).to eq(institution
        .schoolterm_enrollment_list(sample_schoolterm))
    end

    it '-schoolterm_enrollment(sample_schoolterm)' do
      enrollment_for_the_school_term = institution.schoolterm_enrollment_list(sample_schoolterm)
                                                  .count
      expect(enrollment_for_the_school_term).to eq(institution
        .schoolterm_enrollment(sample_schoolterm))
    end

    # Active record objects
    it '-schoolterm_inactive_registrations_list(sample_schoolterm)' do
      inactive_registration_list_for_the_school_term =  \
        institution.schoolterm_enrollment_list(sample_schoolterm).inactive
      expect(inactive_registration_list_for_the_school_term)
        .to eq(institution.schoolterm_inactive_registrations_list(sample_schoolterm))
    end

    # Count, number of inactive registrations (for this institution) in that schoolterm
    it '-schoolterm_inactive_registrations(sample_schoolterm)' do
      inactive_registrations_for_the_school_term = \
        institution.schoolterm_enrollment_list(sample_schoolterm).inactive.confirmed.count
      expect(inactive_registrations_for_the_school_term)
        .to eq(institution.schoolterm_inactive_registrations(sample_schoolterm))
    end

    it '-schoolterm_quota_info(sample_schoolterm)' do
      institution_quotas_for_the_term = \
        Placesavailable.for_institution_on_schoolterm(institution, sample_schoolterm)

      expect(institution_quotas_for_the_term)
        .to eq institution.schoolterm_quota_info(sample_schoolterm)
    end

    it '-schoolterm_authorized_quota(sample_schoolterm)' do
      schoolterm_authorized_quota = institution
                                    .schoolterm_quota_info(sample_schoolterm).first.authorized
      expect(schoolterm_authorized_quota)
        .to eq(institution.schoolterm_authorized_quota(sample_schoolterm))
    end

    it '-remaining_vacancies_on_schoolterm(sample_schoolterm)' do
      spots_left = institution.schoolterm_authorized_quota(sample_schoolterm) \
       - institution.schoolterm_enrollment(sample_schoolterm) \
        + institution.schoolterm_inactive_registrations(sample_schoolterm)
      expect(spots_left).to eq(institution.remaining_vacancies_on_schoolterm(sample_schoolterm))
    end

    # Alias, convenience
    it '-num_schoolterm_inactive_registrations(sample_schoolterm)' do
      inactive_registrations_for_the_term = institution
                                            .schoolterm_inactive_registrations(sample_schoolterm)
      expect(inactive_registrations_for_the_term)
        .to eq(institution.num_schoolterm_inactive_registrations(sample_schoolterm))
    end

    it '-enrollment_reached_maximum_on_schoolterm?(s)' do
      maximum_enrollment_status = institution
                                  .remaining_vacancies_on_schoolterm(sample_schoolterm) == 0
      expect(maximum_enrollment_status)
        .to eq(institution.enrollment_reached_maximum_on_schoolterm?(sample_schoolterm))
    end

    it '-user_contact_name' do
      persons_name = institution.user.contact.name
      expect(persons_name).to eq(institution.user_contact_name)
    end

  end # context

end
