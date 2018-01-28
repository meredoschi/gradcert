class Annotation < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  # New for 2017 - See rspec tests

  # ------------------- References ------------------------

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  # To do ->
  #	before_save :set_absences_to_zero_if_null

  has_paper_trail

  has_many :event, dependent: :restrict_with_exception

  belongs_to :payroll
  belongs_to :registration

  # validates :registration_id, presence: true

  # 	validate :registration_is_active, if: :regular_payroll?

  #  validate :registration_is_inactive, if: :special_payroll?

  validates :payroll_id, presence: true

  validates_uniqueness_of :registration_id, scope: [:payroll_id]

  monetize :supplement_cents

  monetize :discount_cents

  monetize :net_cents

  # 	validate :discount_can_not_be_more_than_gross_amount

  # validate :supplement_can_not_be_more_than_twice_gross_amount

  scope :automatic, -> { where(automatic: true) } # Set to true when created by events

  scope :manual, -> { where(automatic: false) }	# Default (i.e. automatic = false)

  # Computes final impact
  def impact
    supplement - discount
  end

  def detailed
    I18n.t('activerecord.models.annotation').capitalize + ' ' + id.to_s + ' - ' + I18n.t('activerecord.models.payroll').capitalize + ': ' + payroll.name + ' - ' + registration.detailed
  end

  def institution
    registration.student.contact.user.institution
  end

  %i[supplement discount].each do |amounts|
    validates amounts, numericality: { greater_than_or_equal_to: 0 }
  end

  def self.ordered_by_institution_and_contact_name
    joins(registration: [student: [contact: { user: :institution }]]).order('institutions.name', 'contacts.name')
  end

  def regular_payroll?
    !payroll.special
  end

  def special_payroll?
    payroll.special
  end

  # Ensures registration is active
  def registration_is_inactive
    if active_registration?

      errors.add(:registration_id, :must_be_inactive_on_special_payroll)

    end
  end

  # Ensure that registration is active, i.e. is select on regular payroll
  def	registration_is_active
    errors.add(:registration_id, :must_be_active) if inactive_registration?
  end

  # Checks if registration is active
  def active_registration?
    registration = Registration.find(registration_id)

    registration.active
  end

  def inactive_registration?
    !registration.active
  end

  # Ensures registration is active
  def registration_is_active
    if registration.inactive?

      errors.add(:registration_id, :must_be_active_on_regular_payroll)

    end
  end

  # p = Payroll
  def self.prior_to_payroll(p)
    joins(:payroll).where('payrolls.monthworked<?', p.monthworked.last_month)
  end

  def self.adjustment
    where('discount_cents > 0 or supplement_cents>0')
  end

  # Returns the (student's) registration total absences
  def self.absences_for_registration(r)
    absent.for_registration(r).sum(:absences) # .absent filters results
  end

  # Returns the (student's) registration total absences
  def self.actual_absences_for_registration(r)
    absent.for_registration(r).sum(:absences) # .absent filters results
  end

  # Most common annotation type
  def automatic?
    automatic
  end

  # Used sparingly.  Refers to manual supplements or discounts most of the time.
  def manual?
    !automatic
  end

  # To do: test this method properly
  # Useful for manual annotations (including from rake tasks)
  def set_absences_to_zero_if_null
    self.absences = 0 if absences.nil?
   end

  def supplement_can_not_be_more_than_twice_gross_amount
    payroll = self.payroll

    gross = if payroll.regular?

              Scholarship.for_payroll(payroll).first.amount

            else

              self.payroll.amount # i.e. Manual amount

            end

    if supplement > gross * 2

      errors.add(:supplement, :supplement_may_not_be_more_than_twice_gross_amount)

    end
  end

  # The student's (registration) number of absences during the payroll cycle, if any
  def self.num_absences_for_registration_on_payroll(r, p)
    if exists_for_registration_on_payroll?(r, p)

      for_registration_on_payroll(r, p).pluck(:absences)[0] # Important: it is assumed this array will return only one element, so we get the first one.

    else

      0 # returns 0 instead of nil, in order to be more explicit

    end
  end

  def self.for_registration_on_payroll(r, p)
    where(payroll_id: p.id, registration_id: r.id)
  end

  def self.exists_for_registration_on_payroll?(r, p)
    for_registration_on_payroll(r, p).exists?
  end

  # Manual amount option (from development) was suppressed in production
  def discount_can_not_be_more_than_gross_amount
    payroll = self.payroll

    gross = Scholarship.for_payroll(payroll).first.amount

    if discount > gross

      errors.add(:discount, :discount_may_not_be_more_than_gross_amount)

    end
  end

  def self.absent
    where('absences > ?', 0)
  end

  def self.assiduos
    where.not(id: absent)
  end

  def self.frequent
    assiduos # Alias
  end

  def absent?
    (absences > 0)
  end

  def assiduous?
    !absent?
  end

  def frequent?
    assiduous?
  end

  def self.usual
    where(discount_cents: 0, supplement_cents: 0)
  end

  def self.manual
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: usual)
  end

  # a = Annotation
  def usual?
    (discount_cents == 0 && supplement_cents == 0)
  end

  # To do: separate manual from adjustment (concept)
  def manual?
    !usual?
  end

  def adjustment?
    !usual?
  end

  # Annotations confirmed by managers
  def self.confirmed
    where(confirmed: true)
  end

  # Annotations pending confirmation
  def self.pending
    where.not(id: confirmed)
  end

  def confirmed?
    confirmed == true
  end

  def not_prepared?
    confirmed == false
  end

  # Alias to not_prepared?
  def pending?
    confirmed == false
  end

  def net_cents
    supplement_cents.to_i - discount_cents.to_i
  end

  def impactdetails
    impact_amount = number_to_currency(impact)
    supplement_amount = number_to_currency(supplement)
    discount_amount = number_to_currency(discount)

    annotation_impact_details = I18n.t('discounts_and_supplements').capitalize + '-> '

    annotation_impact_details += I18n.t('activerecord.attributes.annotation.virtual.impact') + ': ' + impact_amount

    annotation_impact_details += ' (' + I18n.t('negative') + ')' if impact < 0

    annotation_impact_details += +' [' + I18n.t('activerecord.attributes.annotation.supplement') + ': ' + supplement_amount
    annotation_impact_details += +' ; ' + I18n.t('activerecord.attributes.annotation.discount') + ': ' + discount_amount + ']'

    annotation_impact_details
  end

  # --- TDD ---
  def payroll_name
    payroll.name
  end
  # -----------

  def kind
    @annotation_kind = I18n.t('activerecord.attributes.annotation.virtual.kind') + ': '

    if automatic?

      @annotation_kind += I18n.t('activerecord.attributes.annotation.automatic').downcase

    else

      @annotation_kind += I18n.t('activerecord.attributes.annotation.virtual.manual').downcase

    end

    @annotation_kind
  end

  def self.for_institution_id(institution_id)
    joins(registration: [student: [contact: [{ user: :institution }]]]).where('institutions.id= ? ', institution_id)
  end

  def self.for_institution(i)
    joins(registration: [student: [contact: [{ user: :institution }]]]).where('institutions.id= ? ', i.id)
  end

  def self.skipped
    where(skip: true)
  end

  def self.not_skipped
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: skipped)
  end

  def self.regular
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    not_skipped
  end

  def net_cents
    supplement_cents.to_i - discount_cents.to_i
  end

  def skip?
    skip
  end

  # Sum all annotated absences for a registration id
  def self.absences_for(r)
    for_registration(r).sum(:absences)
  end

  # http://stackoverflow.com/questions/19175084/activerecord-query-through-multiple-joins
  def self.institution_ids
    # 		joins(registration: [ student: [ contact: [ {user: :institution}]]]).order("institutions.name").pluck(:institution_id).uniq
    joins(registration: [student: [contact: [{ user: :institution }]]]).order('institutions.name').pluck('institutions.id').uniq
  end

  def self.for_payroll(p)
    where(payroll_id: p)
  end

  # To do: annotations before payroll p, sum these absences

  def self.for_registration(r)
    where(registration_id: r)
  end

  def self.for_schoolterm(s)
    joins(:registration).where('registrations.schoolterm_id = ? ', s.id)
  end

  def self.ordered_by_contact_name
    joins(registration: { student: :contact }).order('contacts.name')
  end

  # Ordered by most recent
  def self.ordered_by_most_recent_payroll
    joins(:payroll).merge(Payroll.ordered_by_most_recent)
  end

  def namecpf
    registration.namecpf
  end

  def name
    registration.student_name + ' ' + payroll.name
  end

  # To be deprecated
  def full_details
    registration.full_details
  end

  def details
    registration.details
  end

  def absencesinfo
    annotation_absences_info = ''
    skip_i18n = I18n.t('activerecord.attributes.annotation.skip')

    absences_i18n = I18n.t('activerecord.attributes.event.absence')

    if absences.present? && absences > 0
      annotation_absences_info = pluralize(absences, absences_i18n).downcase

      annotation_absences_info += ' - ' + skip_i18n if skip?

    else
      annotation_absences_info = I18n.t('no_absences').capitalize
  end

    annotation_absences_info
  end

  def info
    ' [' + kind + '] ' + absencesinfo + ' - ' + impactdetails
  end

  def fulldetails
    detailed + ' [' + kind + '] ' + absencesinfo + ' - ' + impactdetails
  end
end
