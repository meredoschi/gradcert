class Feedback < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :registration
  belongs_to :payroll
  belongs_to :bankpayment

  # -------------------------------------------------------

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  #   validates :name, presence: true, uniqueness: {case_sensitive: false}, length:  { maximum: 200 }

  validates :registration_id, presence: true

  validates_uniqueness_of :registration_id, scope: [:bankpayment_id]

  validates :comment, length: { maximum: 200 }

  # validate :registration_is_active_on_regular_bankpayment, if: :regular_bankpayment?

  # validate :registration_is_inactive_on_special_bankpayment, if: :special_bankpayment?

  scope :processed, -> { where(processed: true) }

  scope :pending, -> { where(processed: false) }

  def self.ordered_by_contact_name
    joins(registration: [student: :contact]).order('contacts.name')
  end

  def regular_bankpayment?
    !bankpayment.resend?
  end

  def special_bankpayment?
    bankpayment.resend?
  end

  def self.for_payroll(p)
    where(payroll_id: p.id)
  end

  # Ensures registration is active
  def registration_is_active_on_regular_bankpayment
    if registration.inactive? && bankpayment.regular?

      errors.add(:registration_id, :must_be_active_on_regular_bankpayment)

    end
  end

  # Ensures registration is active
  def registration_is_inactive_on_special_bankpayment
    if registration.inactive? && bankpayment.regular?

      errors.add(:registration_id, :may_not_be_active_on_special_bankpayment)

    end
  end

  def name
    bankpayment.name
  end

  def processed?
    processed
  end

  def self.for_bankpayment(p)
    where(bankpayment_id: p.id)
  end

  def self.registration_ids_for_bankpayment(b)
    where(bankpayment_id: b.id).pluck(:registration_id)
  end

  def self.registration_ids
    joins(:registration).pluck(:registration_id)
  end

  def self.registrations
    joins(:registration)
  end

  # New for 2017

  def registration_student_name_id_schoolyear_term
    registration.student_name_id_schoolyear_term
  end

  def self.contextual_on(dt)
    joins(:registration).merge(Registration.contextual_on(dt))
  end

  #   def self.default_scope
  # this notation prevents ambiguity
  #      order(name: :asc)
  # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  #  end

  # ***********************************************************************************************************************************
end
