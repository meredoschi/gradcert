# Allows for easier maintenance of contact personal information
class Personalinfo < ActiveRecord::Base
  has_paper_trail

  # ------------------- References ------------------------

  # Three different contexts here

  belongs_to :municipality # Where person was born
  belongs_to :state	# State which issued id
  belongs_to :country # Nationality (foreigners)

  #
  belongs_to :contact

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  # ************ RSPEC ************

  # SEXES=%w(F M X) # biological sex and gender types
  SEXES = [Settings.personalcharacteristic.female,
           Settings.personalcharacteristic.male,
           Settings.personalcharacteristic.unspecified].freeze
  GENDERS = SEXES #
  #   https://www.ag.gov.au/publications/documents/australiangovernmentguidelinesontherecognitionofsexandgender/australiangovernmentguidelinesontherecognitionofsexandgender.doc

  IDTYPES = [Settings.personaldocument.state_registration,
             Settings.personaldocument.registered_foreigner,
             Settings.personaldocument.passport].freeze

 #	  	validates personaltraits,  presence: true, length: {is: 1}

						 	# Digito verificador do NIT

						   def nit_dv # Brazilian Social Security Number - Verification digit
						     personalinfo_ssn_control_digit = 11 - (ssn_weighted_sum % 11)

						     if personalinfo_ssn_control_digit < 10

						       personalinfo_ssn_control_digit = personalinfo_ssn_control_digit.to_s

						     else

						       personalinfo_ssn_control_digit = '0'

						     end
						     personalinfo_ssn_control_digit
						   end

						   def ssn_weighted_sum
						     personal_info_ssn_weighted_sum = 0

						     factors = [3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

						     (0..9).each do |i|
						       personal_info_ssn_weighted_sum += factors[i] * socialsecuritynumber[i].to_i
						     end

						     personal_info_ssn_weighted_sum
						   end

	validates :state_id, presence:true, if: :citizen?

  # ************ Tested code finish ************

  #
  #   before_validation :squish_whitespaces
  #   before_save :squish_whitespaces
  #   before_update :squish_whitespaces
  #

  # 	validates_inclusion_of :sex, in: SEXES
  # 	validates_inclusion_of :gender, in: GENDERS

  validates :othername, absence: true, unless: :genderdiversity?

  # [:sex, :gender].each do |personaltraits|

  #	  	validates personaltraits,  presence: true, length: {is: 1}

  # end

  validates :sex, presence: true, length: { is: 1 }

  validates :idnumber, presence: true, length: { maximum: 20 }

  validates :socialsecuritynumber, length: { maximum: 20 }

  validates :idtype, length: { maximum: 15 }

  validate :birth_date_cannot_be_in_the_future

  validates :tin, presence: true, length: { is: 11 }

  validates :tin, numericality: { only_integer: true }

  validates_uniqueness_of :tin

  validates_uniqueness_of :socialsecuritynumber, unless: :staff?

  validates :country_id, presence: true, if: :international?

  validates :state_id, presence: true, if: :citizen?

  validates :state_id, absence: true, if: :international?

  validates :country_id, absence: true, if: :citizen?

  validates :othername, presence: true, length: { maximum: 30 }, if: :genderdiversity?

  validates :othername, absence: true, unless: :genderdiversity?

  validates :dob, presence: true

  validates :mothersname, length: { maximum: 100 }

  # Training
  #  validates :mothersname, presence: true,
  # :if => Proc.new{|personalinfo| personalinfo.contact.role.student? }

  # It is assumed students only - registration season
  validates :mothersname, presence: true, unless: :staff?
  validates :socialsecuritynumber, presence: true, unless: :staff?

  validate :nit_is_consistent, unless: :staff?
  #

  #  validates :socialsecuritynumber, presence: true, if: :student_role?
  #
  validates :idnumber, presence: true, length: { maximum: 20 }

  # 	validates :mothersname,  presence: true, length:  { maximum: 100 }, if: :role_is_student?

  #  validates :mothersname,  presence: true, length:  { maximum: 100 },
  #  :if => lambda {|p| p.contact.role.student? }

  validate :cpf_is_consistent # CPF = Brazil's Taxpayer identification number (TIN)

  def staff?
    (contact.present? && contact.role.present? && contact.role.staff?)
  end

  def role_is_student?
    contact.role.student?
  end

  def citizen?
    !international?
  end

  # This assumes Brazilians will use local state id (RG)
  #
  def international?
    #		if registered_foreigner? || passport?

    if registered_foreigner?

      true

    else

      false

    end
  end

  def registered_foreigner?
    if idtype == Settings.personaldocument.registered_foreigner

      true

    else

      false

    end
  end

  def passport?
    if idtype == Settings.personaldocument.passport

      true

    else

      false

    end
  end

  def genderdiversity?
    if sex.present? && gender.present? && ((sex != gender) || sex == 'X' || gender == 'X')

      true

    else

      false

    end
  end

  def cpf_dv1 # Brazilian Taxpayer identification number - First verification digit
    v = 0

    (1..9).each do |k|
      v += k * tin[k - 1].to_i
    end

    v = v % 11
    v = v % 10

    v
  end

  # Segundo digito verificador do CPF

  def cpf_dv2 # Brazilian Taxpayer identification number - Second verification digit
    v = 0

    (1..8).each do |k|
      v += k * tin[k].to_i
    end

    v += 9 * cpf_dv1.to_i # Chama DV1

    v = v % 11
    v = v % 10

    v
  end

  def mothers_name_is_present
    errors.add(:mothersname, :missing) unless mothersname.present?
  end

  # Brazilian Social Security Number
  def nit_is_consistent
    if socialsecuritynumber[10] == nit_dv

      true

    else

      errors.add(:socialsecuritynumber, :inconsistent)

      false

    end
  end

  # Brazilian Taxpayer id
  def cpf_is_consistent
    if (tin[9].to_i == cpf_dv1) && (tin[10].to_i == cpf_dv2)

      true

    else

      errors.add(:tin, :inconsistent)

      false

    end
  end

  def male?
    (!genderdiversity? && sex == 'M')
  end

  def female?
    (!genderdiversity? && sex == 'F')
  end

  def student_role?
    contact.role.student? if contact.role.present?
  end

  def birth_date_cannot_be_in_the_future
    return unless dob.present? && dob > Date.today
    errors.add(:dob, :may_not_be_in_the_future)
  end

  protected

  def squish_whitespaces
    # Added check for null (contact first created dynamically on the user's controller)
    if tin.present? && idnumber.present?

      self.tin = tin.squish
      self.idnumber = idnumber.squish

    end

    self.mothersname = mothersname.squish if mothersname.present?
  end
end
