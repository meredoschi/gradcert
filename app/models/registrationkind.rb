# Implemented in order to properly account for "special" registrations
class Registrationkind < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :registration

  scope :regular, -> { where(regular: true) }

  scope :makeup, -> { where(makeup: true) }

  scope :repeat, -> { where(repeat: true) }

  # Tested code

  def regular_i18n
    I18n.t('activerecord.attributes.registrationkind.regular').downcase
  end

  def makeup_i18n
    I18n.t('activerecord.attributes.registrationkind.makeup').downcase
  end

  def repeat_i18n
    I18n.t('activerecord.attributes.registrationkind.repeat').downcase
  end

  # Pending
  def school_term_name
    registration.school_term_name
  end

  # Pending

  def school_year_name
    registration.schoolyear.name
  end

  # Pending
  def name
    student_name + ', ' + I18n.t('activerecord.models.registration') + ' ' + status \
    + ', ' + school_year_name + ' (' + school_term_name + ')' # alias
  end

  # Tested code finish

  # Alias (for convenience)
  def self.normal
    regular
  end

  def self.special
    where.not(id: regular)
  end

  def status
    if regular == true then regular_i18n
    elsif makeup == true then makeup_i18n
    elsif repeat == true then repeat_i18n
    else I18n.t('activerecord.models.registrationkind') + ': ???'
      # 'Defensive programming', validations should prevent this
    end
  end

  def student_name
    registrationkind.registration.student.contact.name
  end

  # From a previous registration
  def related_to_a_previous_registration?
    (makeup? || repeat?) && previousregistrationid.positive?
  end

  # i.e. Regular registration
  def not_related_to_a_previous_registration?
    !related_to_a_previous_registration?
  end

  def regular?
    regular == true
  end

  def makeup?
    makeup == true
  end

  def repeat?
    repeat == true
  end

  # Does not refer to a previous registration, e.g. regular
  def self.not_related_to_a_previous_registration?
    where(previousregistrationid: nil)
  end

  # Used in fixes:makeupschedules_17
  def self.related_to_a_previous_registration?
    where.not(id: not_related_to_a_previous_registration)
  end
end
