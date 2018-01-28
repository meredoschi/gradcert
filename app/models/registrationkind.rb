class Registrationkind < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :registration

  scope :regular, -> { where(regular: true) }

  scope :makeup, -> { where(makeup: true) }

  scope :repeat, -> { where(repeat: true) }

=begin

# 	has_many  :supervisor, :foreign_key => 'contact_id'

# -------------------------------------------------------

# ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  validates :name, presence: true, uniqueness: {case_sensitive: false}, length:  { maximum: 200 }

  def self.default_scope
      # this notation prevents ambiguity
      order(name: :asc)
      # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

=end

  # ***********************************************************************************************************************************

  def status
    profile = if regular == true then I18n.t('activerecord.attributes.registrationkind.regular').downcase
              elsif makeup == true then I18n.t('activerecord.attributes.registrationkind.makeup').downcase
              elsif repeat == true then I18n.t('activerecord.attributes.registrationkind.repeat').downcase
              else I18n.t('activerecord.models.registrationkind') + ': ???'
    end
  end

  def name
    registration.student.contact.name + ', ' + I18n.t('activerecord.models.registration') + ' ' + status + ', ' + registration.schoolyear.name + ' (' + registration.school_term_name + ')' # alias
  end

  # From a previous registration
  def related_to_a_previous_registration?
    (makeup? || repeat?) && previousregistrationid > 0
  end

  # i.e. Regular registration
  def not_related_to_a_previous_registration?
    !related_to_a_previous_registration?
  end

  def regular?
    if regular == true

      true

    else

      false

    end
  end

  def makeup?
    if makeup == true

      true

    else

      false

    end
  end

  def repeat?
    if repeat == true

      true

    else

      false

    end
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
