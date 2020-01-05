# Display format helper (used in views)
module ApplicationdisplayHelper
require 'i18n'

  # Display summary information for the user, when logged in
  def display_header(user)
    if logged_in?(user)

      if Rails.env == 'development'

        html = '<span class="label">' + Dir.pwd + '</span>' + ' '

        html += '<strong>' + user.institution.name + '</strong> '

        html += ' | '

      else

        html = ''

      end

      html += '<strong>'
      html += Settings.system_abbreviation
      html += '</strong> | '

      html += profile(user)

      html += ' | <strong> '

      html += user.contact.name
      html += '</strong> | '

      html += user.email

      html += ' | <strong> '

      html += user.id.to_s

      html += '</strong>'

      html.html_safe

    end

end

  # Shorthand method for translating activerecord attributes
  def ta(attr)
    prefix = 'activerecord.attributes.'
    text = prefix + attr
    t(text).html_safe
  end

  # Shorthand method for translating activerecord models
  def tm(modelname)
    prefix = 'activerecord.models.'
    text = prefix + modelname
    t(text).html_safe
  end

  # display Brazilian greeting
  def brazilian_greeting(user)
    if user.contact.personalinfo.genderdiversity?

      @txt = I18n.t('welcome.diversity')

    elsif user.contact.female?

      @txt = I18n.t('welcome.female')

    elsif user.contact.male?

      @txt = I18n.t('welcome.male')
    end

    @txt + ' ' + user.contact.name
  end

  # Works for integers
  def dash_when_none(n)
    if n != 0

      n.to_i

    else

      '—'.html_safe

    end
  end

  def days_for_month(m)
    Time.days_in_month(m.month.to_i, m.year.to_i + 1) # Needed +1 in 2016 to account for leap year.
  end

  def display_program_sector(program)
    txt = ''

    txt = txt + t('abbreviation.pap') + ' ' if program.pap

    txt += t('abbreviation.medicalresidency') if program.medres

    txt.html_safe
  end

  # Functional area.  Pap, Medical Residency.

  def display_sector(modelname)
    res = ''

    res += I18n.t('abbreviation.pap') if modelname.pap?

    res += I18n.t('abbreviation.medres') if modelname.medres?

    res.html_safe
  end

  def display_date_finished(modelname)
    res = if modelname.finish.present?

            I18n.l(modelname.finish)

          else

            '-'

          end

    res.html_safe
  end

  def display_finish_label(modelname)
    res = if modelname.finish.present?

            ta(modelname.finish)

          else

            t('still_valid')

          end

    res.html_safe
  end

  def blank_char
    '_'.html_safe
  end

  def trim_text(txt)
    l = txt.length

    if l > 50

      txt = txt[0..50]

      txt += '...'

    end

    txt.html_safe
  end

  def as_ordinal(n)
    txt = n.ordinalize

    if txt == 1.ordinalize then return I18n.t('ordinal.first').html_safe
    elsif txt == 2.ordinalize then return I18n.t('ordinal.second').html_safe
    elsif txt == 3.ordinalize then return I18n.t('ordinal.third').html_safe
    elsif txt == 4.ordinalize then return I18n.t('ordinal.fourth').html_safe
    elsif txt == 5.ordinalize then return I18n.t('ordinal.fifth').html_safe
    elsif txt == 6.ordinalize then return I18n.t('ordinal.sixth').html_safe
    elsif txt == 7.ordinalize then return I18n.t('ordinal.seventh').html_safe
    elsif txt == 8.ordinalize then return I18n.t('ordinal.eighth').html_safe
    elsif txt == 9.ordinalize then return I18n.t('ordinal.ninth').html_safe
    end

  end

  # --- Arithmetic Functions ---
  # Returns percent from total.  Performs conversion to float since most data is store as integer

  # http://guides.rubyonrails.org/active_support_core_extensions.html
  # http://stackoverflow.com/questions/5502761/why-is-division-in-ruby-returning-an-integer-instead-of-decimal-value

  def delta(previous, current)
    result = (current.to_f - previous.to_f) / previous.to_f * 100

    if result.nan? || previous.to_i.zero?

      return '---'.html_safe

    else

      return result.to_s(:percentage, precision: 1)

    end
  end

  def to_percent(a, b)
    result = number_to_percentage(a * 100 / b, format: '%n', precision: 1)

    if result.nan?

      return '---'.html_safe

    else

      return result.html_safe

    end
  end

  # with sign
  def percent(a, b)
    result = (a.to_f / b.to_f) * 100

    if result.nan?

      return '---'.html_safe

    else

      return result.to_s(:percentage, precision: 2)

    end
  end

  def initcap(s)
    # http://stackoverflow.com/questions/5654488/does-ruby-or-rails-have-a-method-to-capitalize-the-first-character-only

    l = s.length

    s[0] = s[0].upcase + s[1..l]
  end

  # Marcelo
  # http://stackoverflow.com/questions/3664181/rails-or-ruby-yes-no-instead-of-true-false

  def active?(boolean)
    boolean ? I18n.t('active') : I18n.t('inactive')
  end

  # boolean value
  def yes_no(bool)

#    affirmative='yes'.capitalize
    affirmative=I18n.t('yay').capitalize
    negative=I18n.t('nay').capitalize

     bool ? affirmative : negative

  end

  def yes_not_yet(boolean)
    boolean ? t('yes').capitalize : t('not_yet').capitalize

  end

  def tickmark(boolean)
    boolean ? "\u2713".html_safe : ''.html_safe
  end

  def display_if_present(obj)
    if obj.present?

      return

      obj.html_safe

    else

      '---'.html_safe

    end
  end

  # Show it (if exists)
  def show_it(obj, _attrib)
    if obj != null

      return

      obj.attrib.html_safe

    else

      null

    end
  end

  # if it exists - June 2017
  def show_when(dt_time)
    result = '--'

    result = I18n.l(dt_time) if dt_time

    result.html_safe
  end

  def display_if_exists(attrib_label, attrib)
    if attrib?

      concat(attrib_label)
      concat(': ')
      concat(attrib)

    end
  end


def display_non_zero_amount(moneyfigure)
  if moneyfigure != 0

    humanized_money_with_symbol(moneyfigure)

  else

    ''.html_safe

  end
end

# http://archive.railsforum.com/viewtopic.php?id=4812
def comment(&block)
  # SWALLOW THE BLOCK
end

# Integers
def display_if_not_zero(n)
  if n != 0

    n.to_i

  else

    ''.html_safe

  end
end

end
