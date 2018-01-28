class Completion < ActiveRecord::Base
  belongs_to :registration

  scope :mustmakeup, -> { where(mustmakeup: true) }

  boolean_attribs = %i[inprogress pass failure mustmakeup dnf]

  validates_inclusion_of boolean_attribs - [:inprogress], in: [false], if: :in_progress?
  validates_inclusion_of [:inprogress], in: [true], unless: :not_in_progress?

  validates_inclusion_of boolean_attribs - [:pass], in: [false], if: :pass?
  validates_inclusion_of [:pass], in: [true], unless: :not_pass?

  validates_inclusion_of boolean_attribs - [:failure], in: [false], if: :failure?
  validates_inclusion_of [:failure], in: [true], unless: :not_failure?

  validates_inclusion_of boolean_attribs - [:mustmakeup], in: [false], if: :mustmakeup?
  validates_inclusion_of [:mustmakeup], in: [true], unless: :makeup_not_required?

  validates_inclusion_of boolean_attribs - [:dnf], in: [false], if: :dnf?
  validates_inclusion_of [:dnf], in: [true], unless: :something_other_than_dnf?

  def status
    profile = if inprogress == true then I18n.t('activerecord.attributes.completion.inprogress')
              elsif pass == true then I18n.t('activerecord.attributes.completion.pass')
              elsif failure == true then I18n.t('activerecord.attributes.completion.failure')
              elsif mustmakeup == true then I18n.t('activerecord.attributes.completion.mustmakeup')
              elsif dnf == true then I18n.t('activerecord.attributes.completion.dnf')
              else I18n.t('activerecord.models.completion') + ': ???'
    end
  end

  def name
    registration.student.contact.name + ', ' + status + ', ' + registration.schoolyear.name + ' (' + registration.school_term_name + ')' # alias
  end
  # Affirmatives

  def in_progress?
    if inprogress == true

      true

    else

      false

    end
  end

  def pass?
    if pass == true

      true

    else

      false

    end
  end

  def failure?
    if failure == true

      true

    else

      false

    end
  end

  def mustmakeup?
    if mustmakeup == true

      true

    else

      false

    end
  end

  def dnf?
    if dnf == true

      true

    else

      false

    end
  end

  # Negatives
  # All attributes ->
  #		return ( (inprogress==true) || (pass==true) || (failure==true) || (mustmakeup==true)  || (dnf==true)  )

  def not_in_progress?
    ((pass == true) || (failure == true) || (mustmakeup == true) || (dnf == true))
  end

  def not_failure?
    ((inprogress == true) || (pass == true) || (mustmakeup == true) || (dnf == true))
  end

  def something_other_than_dnf?
    ((inprogress == true) || (pass == true) || (failure == true) || (mustmakeup == true))
  end

  # If any of the other attributes is true.  In reality this will be restricted to one
  def not_pass?
    ((inprogress == true) || (pass == true) || (mustmakeup == true) || (dnf == true))
  end

  # Not "must_makeup?"
  def makeup_not_required?
    ((inprogress == true) || (pass == true) || (failure == true) || (dnf == true))
  end
end
