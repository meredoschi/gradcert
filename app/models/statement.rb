class Statement < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :bankpayment

  belongs_to :registration

  # -------------------------------------------------------

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  #  validates :name, presence: true, uniqueness: {case_sensitive: false}, length:  { maximum: 200 }

  validates_uniqueness_of :registration_id, scope: [:bankpayment_id]

  monetize :grossamount_cents

  monetize :netamount_cents

  monetize :incometax_cents

  monetize :socialsecurity_cents

  monetize :childsupport_cents

  #  def self.default_scope
  # this notation prevents ambiguity
  #       ordered_by_contact_name
  # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  # 	end

  # ***********************************************************************************************************************************

  # 	 scope :institution_search, ->(institution) { from_institution_id(institution.id) }

  scope :institution_search, ->(institution) { for_institution_id(institution) }

  #  http://stackoverflow.com/questions/22473391/custom-search-with-ransacker

  def self.ransackable_scopes(_auth_object = nil)
    [:institution_search]
  end

  def student_name
    registration.student_name
   end

  # Statements from students registered at the institution
  # Ransackable
  def self.for_institution_id(i)
    joins(registration: { student: { contact: { user: :institution } } }).where('institutions.id = ? ', i)
  end

  def self.ordered_by_most_recent_payroll_contact_name
    joins(bankpayment: :payroll).joins(registration: { student: :contact }).order('payrolls.dayfinished desc, contacts.name')
  end

  def self.ordered_by_contact_name
    joins(registration: { student: :contact }).order('contacts.name')
  end

  # For 2017 - Statements Report DIRF
  def self.ordered_by_contact_name_and_payment_date
    joins(registration: { student: :contact }).joins(bankpayment: :payroll).order('contacts.name, payrolls.paymentdate')
  end

  def bankpayment_name
    bankpayment.name
  end

  def self.for_bankpayment(b)
    joins(:bankpayment).where(bankpayment_id: b.id)
   end

  def self.for_registration(r)
    joins(:registration).where(registration_id: r.id)
   end

  def self.for_registration_on_bankpayment(r, b)
    where(registration_id: r.id, bankpayment_id: b.id)
   end

  def self.institution_ids_for_bankpayment(b)
    joins(:bankpayment).joins(registration: { student: { contact: { user: :institution } } }).where(bankpayment_id: b.id).pluck('institutions.id').sort.uniq
   end

  def name
    registration.name + ' ' + bankpayment.payroll.name
   end

  # Return bankpayment ids
  def self.bankpayment_ids
    joins(:bankpayment).pluck('bankpayments.id').sort.uniq
   end

  # Return institution ids
  def self.institution_ids
    joins(:registration).merge(Registration.institutions).pluck('institutions.id').sort.uniq
   end

  # Registration ids with statements
  # To do: implement school_term
  def self.registration_ids
    joins(:registration).pluck('registrations.id').sort.uniq
   end

  def self.from_institution_id(i)
    institution = Institution.find(i)

    joins(registration: { student: :contact }).merge(Contact.from_institution(institution))
   end

  def self.from_institution(i)
    joins(registration: { student: :contact }).merge(Contact.from_institution(i))
   end
end
