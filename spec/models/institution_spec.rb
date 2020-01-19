# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Institution, type: :model do
  let(:sample_payroll) { FactoryBot.create(:payroll, :personal_taxation) } # Monthly payroll
  let(:institution) { FactoryBot.create(:institution) }
  let(:sample_schoolterm) { FactoryBot.create(:schoolterm) }
  let(:placesavailable)  { FactoryBot.create(:placesavailable) }

  context 'Associations' do
    it { is_expected.to belong_to(:institutiontype) }

    it {
      is_expected.to have_many(:characteristic).dependent(:restrict_with_exception)
                                               .inverse_of(:institution)
    }
    it {
      is_expected.to have_many(:college).dependent(:restrict_with_exception)
                                        .inverse_of(:institution)
    }
    it {
      is_expected.to have_many(:healthcareinfo).dependent(:restrict_with_exception)
                                               .inverse_of(:institution)
    }
    it {
      is_expected.to have_many(:placesavailable).dependent(:restrict_with_exception)
                                                .inverse_of(:institution)
    }
    it {
      is_expected.to have_many(:researchcenter).dependent(:restrict_with_exception)
                                               .inverse_of(:institution)
    }
    it {
      is_expected.to have_many(:roster).dependent(:restrict_with_exception)
                                       .inverse_of(:institution)
    }
    it {
      is_expected.to have_many(:user).dependent(:restrict_with_exception)
                                     .inverse_of(:institution)
    }

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
      pending('registrations, payroll, annotations to be reviewed')
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

    it '#ordered_by_name' do
      institutions_ordered_by_name = Institution.order(name: :asc) # notation to prevent ambiguity
      expect(institutions_ordered_by_name).to eq(Institution.ordered_by_name)
    end

    it '#with_active_programs' do
      pending('development-schoolyears - program accreditations to be reviewed')
      institutions_with_active_programs = Institution.joins(:program).merge(Program.active)
      expect(institutions_with_active_programs).to eq(Institution.with_active_programs)
    end

    it '#pap' do
      pap_participating_institutions = Institution.joins(:program).merge(Program.pap)
      expect(pap_participating_institutions).to eq(Institution.pap)
    end

    it '#medres' do
      medical_residency_participating_institutions = Institution
                                                     .joins(:program).merge(Program.medres)
      expect(medical_residency_participating_institutions).to eq(Institution.medres)
    end

    it '#gradcert' do
      graduate_certificate_participating_institutions = Institution
                                                        .joins(:program).merge(Program.gradcert)
      expect(graduate_certificate_participating_institutions).to eq(Institution.gradcert)
    end

    it '#undergraduate' do
      undergraduate_degree_awarding_institutions = Institution.where(undergraduate: true)
      expect(undergraduate_degree_awarding_institutions).to eq(Institution.undergraduate)
    end

    it '#with_users' do
      institutions_with_users = Institution.joins(:user).uniq
      expect(institutions_with_users).to eq(Institution.with_users)
    end

    it '#with_pap_users' do
      institutions_with_pap_users = Institution.joins(:user).merge(User.pap)
      expect(institutions_with_pap_users).to eq(Institution.with_pap_users)
    end

    it '#with_medres_users' do
      institutions_with_medres_users = Institution.joins(:user).merge(User.medres)
      expect(institutions_with_medres_users).to eq(Institution.with_medres_users)
    end

    it '#with_users_seen_by_readonly' do
      institutions_with_users_seen_by_readonly = Institution.with_users
                                                            .merge(User.visible_to_readonly)
      expect(institutions_with_users_seen_by_readonly)
        .to eq(Institution.with_users_seen_by_readonly)
    end

    # i.e. with more detailed information (characteristics) entered in the system
    it '#with_characteristic' do
      institutions_with_characteristics_info = Institution.joins(:characteristic).order(:name)
      expect(institutions_with_characteristics_info).to eq(Institution.with_characteristic)
    end

    # with college (educational institution) infrastructure
    it '#with_college' do
      institutions_with_college = Institution.joins(:college).order(:name)
      expect(institutions_with_college).to eq(Institution.with_college)
    end

    # i.e. with detailed health care infrastructure entered in the system
    it '#with_healthcareinfo' do
      institutions_with_healthcare_info = Institution.joins(:healthcareinfo).order(:name)
      expect(institutions_with_healthcare_info).to eq(Institution.with_healthcareinfo)
    end

    # without more detailed information (characteristics) entered in the system
    it '#without_characteristic' do
      institutions_without_characteristics_info = Institution
                                                  .where.not(id: Institution.with_characteristic)
      expect(institutions_without_characteristics_info).to eq(Institution.without_characteristic)
    end

    # without college
    it '#without_college' do
      institutions_without_college = Institution
                                     .where.not(id: Institution.with_college)
      expect(institutions_without_college).to eq(Institution.without_college)
    end

    # i.e. without detailed health care infrastructure entered in the system
    it '#without_healthcareinfo' do
      institutions_without_healthcare_info = Institution
                                             .where.not(id: Institution.with_healthcareinfo)
      expect(institutions_without_healthcare_info).to eq(Institution.without_healthcareinfo)
    end

    # i.e. without detailed health care infrastructure entered in the system
    it '#without_researchcenter' do
      institutions_without_research_center_info = Institution
                                                  .where.not(id: Institution.researchcenter)
      #      scope :researchcenter, -> { joins(:researchcenter) }
      expect(institutions_without_research_center_info).to eq(Institution.without_researchcenter)
    end
  end

  context 'Instance methods' do
    context 'development-schoolyears' do

      it '-programs' do
        programs_offered_by_the_institution=institution.program
        expect(programs_offered_by_the_institution).to eq(institution.programs)
      end

      it '-shortname' do
        institution_short_name = institution.name.truncate(Institution::ABBREVIATION_LENGTH)
        expect(institution_short_name).to eq(institution.shortname)
      end
    end

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
      pending('development-schoolyears schoolterm to be reviewed')
      enrollment_list_for_the_school_term = Registration.on_schoolterm(sample_schoolterm)
                                                        .from_institution(institution)
      expect(enrollment_list_for_the_school_term).to eq(institution
        .schoolterm_enrollment_list(sample_schoolterm))
    end

    it '-schoolterm_enrollment(sample_schoolterm)' do
      pending('development-schoolyears schoolterm to be reviewed')

      enrollment_for_the_school_term = institution.schoolterm_enrollment_list(sample_schoolterm)
                                                  .count
      expect(enrollment_for_the_school_term).to eq(institution
        .schoolterm_enrollment(sample_schoolterm))
    end

    # Active record objects
    it '-schoolterm_inactive_registrations_list(sample_schoolterm)' do
      pending('development-schoolyears schoolterm to be reviewed and then registrations')

      inactive_registration_list_for_the_school_term =  \
        institution.schoolterm_enrollment_list(sample_schoolterm).inactive
      expect(inactive_registration_list_for_the_school_term)
        .to eq(institution.schoolterm_inactive_registrations_list(sample_schoolterm))
    end

    # Count, number of inactive registrations (for this institution) in that schoolterm
    it '-schoolterm_inactive_registrations(sample_schoolterm)' do
      pending('development-schoolyears schoolterm to be reviewed and then registrations')
      inactive_registrations_for_the_school_term = \
        institution.schoolterm_enrollment_list(sample_schoolterm).inactive.confirmed.count
      expect(inactive_registrations_for_the_school_term)
        .to eq(institution.schoolterm_inactive_registrations(sample_schoolterm))
    end

    it '-schoolterm_quota_info(sample_schoolterm)' do
      pending('development-schoolyears schoolterm places available to be reviewed')
      institution_quotas_for_the_term = \
        Placesavailable.for_institution_on_schoolterm(institution, sample_schoolterm)

      expect(institution_quotas_for_the_term)
        .to eq institution.schoolterm_quota_info(sample_schoolterm)
    end

    it '-schoolterm_authorized_quota(sample_schoolterm)' do
      pending('development-schoolyears schoolterm places available to be reviewed')
      schoolterm_authorized_quota = institution
                                    .schoolterm_quota_info(sample_schoolterm).first.authorized
      expect(schoolterm_authorized_quota)
        .to eq(institution.schoolterm_authorized_quota(sample_schoolterm))
    end

    it '-remaining_vacancies_on_schoolterm(sample_schoolterm)' do
      pending('depends on schoolterm_authorized_quota')
      spots_left = institution.schoolterm_authorized_quota(sample_schoolterm) \
       - institution.schoolterm_enrollment(sample_schoolterm) \
        + institution.schoolterm_inactive_registrations(sample_schoolterm)
      expect(spots_left).to eq(institution.remaining_vacancies_on_schoolterm(sample_schoolterm))
    end

    # Alias, convenience
    it '-num_schoolterm_inactive_registrations(sample_schoolterm)' do
      pending('alias')
      inactive_registrations_for_the_term = institution
                                            .schoolterm_inactive_registrations(sample_schoolterm)
      expect(inactive_registrations_for_the_term)
        .to eq(institution.num_schoolterm_inactive_registrations(sample_schoolterm))
    end

    it '-enrollment_reached_maximum_on_schoolterm?(sample_schoolterm)' do
      pending('development-schoolyears - program accreditations to be reviewed')
      maximum_enrollment_status = institution
                                  .remaining_vacancies_on_schoolterm(sample_schoolterm) == 0
      expect(maximum_enrollment_status)
        .to eq(institution.enrollment_reached_maximum_on_schoolterm?(sample_schoolterm))
    end

    it '-with_healthcare_info?' do
      is_health_care_facility = institution.healthcareinfo.exists?
      expect(is_health_care_facility).to eq(institution.with_healthcare_info?)
    end

    it '-with_research_center?' do
      is_research_center = institution.researchcenter.exists?
      expect(is_research_center).to eq(institution.with_research_center?)
    end

    it '-with_college?' do
      is_college = institution.college.exists?
      expect(is_college).to eq(institution.with_college?)
    end

    it '-with_characteristic?' do
      is_characteristics_info_in_the_system = institution.characteristic.exists?
      expect(is_characteristics_info_in_the_system).to eq(institution.with_characteristic?)
    end

    it '-with_programs?' do
      does_institution_have_at_least_one_program = institution.program.exists?
      expect(does_institution_have_at_least_one_program).to eq(institution.with_programs?)
    end

    it '-with_active_programs?' do
      pending('development-schoolyears - program accreditations to be reviewed')
      does_institution_have_at_least_one_active_program = institution.program.active.exists?
      expect(does_institution_have_at_least_one_active_program)
        .to eq(institution.with_active_programs?)
    end

    it '-with_infrastructure?' do
      status = false
      if institution.with_research_center? || institution.with_college? \
        || institution.with_healthcare_info?

        status = true
      end

      expect(status).to eq(institution.with_infrastructure?)
    end

    it '-with_gradcert_programs?' do
      status = false
      status = true if institution.program.gradcert.count > 0
      expect(status).to eq(institution.with_gradcert_programs?)
    end

    it '-with_medres_programs?' do
      status = false
      status = true if institution.program.medres.count > 0
      expect(status).to eq(institution.with_medres_programs?)
    end

    it '-with_pap_programs?' do
      status = false
      status = true if institution.program.pap.count > 0
      expect(status).to eq(institution.with_pap_programs?)
    end
  end

  it '-higherlearning?' do
    is_university_level_institution = (institution.undergraduate || institution.with_pap_programs? \
      || institution.with_medres_programs? || institution.with_gradcert_programs?)
    expect(is_university_level_institution).to eq(institution.higherlearning?)
  end
end
