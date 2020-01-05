class Placesavailable < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :institution
  belongs_to :schoolterm

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  #  validates :name, presence: true, uniqueness: {case_sensitive: false}, length:  { maximum: 200 }

  has_paper_trail

  validates_uniqueness_of :institution_id, scope: [:schoolterm_id]

  # validate :authorized_must_not_exceed_limit

  def authorized_must_not_exceed_limit
    @registrations = Registration.all
    @schoolterms = Schoolterm.all
    @placesavailable = Placesavailable.all

    latest_term = @schoolterms.latest
    previous_term = latest_term.previous.first

    latest_term_registrations = @registrations.on_schoolterm(latest_term)

    latest_term_registrations_confirmed_inactive = latest_term_registrations.inactive.confirmed

    num_latest_term_registrations = latest_term_registrations.count

    num_latest_term_registrations_confirmed_inactive = latest_term_registrations_confirmed_inactive.count

    previous_term_registrations = @registrations.on_schoolterm(previous_term)
    num_previous_term_registrations = previous_term_registrations.count
    previous_term_registrations_on_two_year_programs = previous_term_registrations.two_year_program # Pap is at most 2

    num_previous_term_registrations_on_two_year_programs = previous_term_registrations_on_two_year_programs.count

    authorized_places_available = @placesavailable.authorized_for_latest_term

    if @placesavailable.for_schoolterm(latest_term).for_institution(institution).first.present?

      current_scholarships_made_available_to_the_institution = @placesavailable.for_schoolterm(latest_term).for_institution(institution).first.authorized

    else

      current_scholarships_made_available_to_the_institution = 0

    end

    projected_total = authorized_places_available + num_previous_term_registrations_on_two_year_programs - current_scholarships_made_available_to_the_institution

    # 	maximum_number_scholarships=Settings.num_scholarships_offered.pap
    maximum_number_scholarships = latest_term.scholarshipsoffered

    #	if self.authorized+projected_total>maximum_number_scholarships

    if authorized + projected_total > (maximum_number_scholarships + num_latest_term_registrations_confirmed_inactive)

      errors.add(:authorized, :exceeds_total_number_of_scholarships)

    end
  end

  def self.for_schoolterm(s)
    joins(:schoolterm).where('schoolterms.id = ? ', s.id)
  end

  # Scholarships authorized (made available)
  def self.authorized_for_schoolterm(s)
    for_schoolterm(s).sum(:authorized)
  end

  # Scholarships authorized (made available)
  def self.authorized_for_latest_term
    s = Schoolterm.latest

    for_schoolterm(s).sum(:authorized)
  end

  def self.for_institution_on_schoolterm(i, s)
    where(institution_id: i, schoolterm_id: s)
  end

  def self.for_institution(i)
    where(institution_id: i)
  end

  def self.on_schoolyear(s)
    where(schoolyear_id: s)
  end

  # Shows information for scholarships accredited, requested and authorized in a single line
  # Handles undefined cases as well (null values).  Allowed in 2017 due to lack of data
  # Passed test: placesavailable_spec.rb
  def summary
    sep = '; '

    virtual_attrib = '['

    virtual_attrib += I18n.t('activerecord.attributes.placesavailable.accredited').downcase + ' '

    accredited = self.accredited

    # Was nill in 2017
    virtual_attrib += if accredited.nil?

                        I18n.t('undefined_value') + sep

                      else

                        accredited.to_s + sep

                      end

    virtual_attrib += I18n.t('activerecord.attributes.placesavailable.requested').downcase + ' '

    requested = self.requested

    # Was nill in 2017
    virtual_attrib += if requested.nil?

                        I18n.t('undefined_value') + sep

                      else

                        requested.to_s + sep

                      end

    virtual_attrib += I18n.t('activerecord.attributes.placesavailable.authorized').downcase + ' '

    authorized = self.authorized

    # Allow for nil cases due to unavailable data in 2017
    virtual_attrib += if authorized.nil?

                        I18n.t('undefined_value')

                      else

                        authorized.to_s

                      end

    virtual_attrib += ']'

    virtual_attrib
  end

  def name
    'A'
  end

  def institution_registrations
    Registration.from_institution(institution)
  end

  # Institution registrations for that schoolterm
  def registrations
    Registration.from_institution(institution).on_schoolterm(schoolterm)
  end

  def registered_veterans
    institution_registrations.for_schoolterm(Schoolterm.latest.previous.first).veterans
  end

  def registered_veterans_active
    registered_veterans.active
  end

  # Within the context
  def num_total_active
    num_active_registrations + num_registered_veterans_active
  end

  def num_still_available
    authorized - num_active_registrations
  end

  def num_registered_veterans
    registered_veterans.count
  end

  def num_registered_veterans_active
    registered_veterans_active.count
  end

  def active_registrations
    registrations.active
  end

  def num_active_registrations
    active_registrations.count
  end

  # Generally speaking, cancellations which await for manager approval
  def inactive_registrations_pending
    registrations.pending.inactive
  end

  # Authorized, confirmed
  def inactive_registrations
    registrations.confirmed.inactive
  end

  def num_inactive_registrations
    inactive_registrations.count
  end

  def registrations_deactivation_pending
    registrations.inactive.pending
  end

  # Alias for convenience
  def inactive_registrations_pending
    registrations_deactivation_pending
  end

  # Alias for convenience
  def num_inactive_registrations_pending
    num_registrations_deactivation_pending
  end

  def num_registrations_deactivation_pending
    registrations_deactivation_pending.count
  end

  def num_registrations
    registrations.count
  end

  def self.default_scope
    # this notation prevents ambiguity

    joins(:institution).order('institutions.name')

    #  order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

#  For local admins - deprecated - used in welcome view
#  def places_available?(user)
#    Placesavailable.where(institution_id: user.institution_id, schoolterm_id: Schoolterm.latest,
#                          allowregistrations: true).exists?
#  end

  # ***********************************************************************************************************************************
end
