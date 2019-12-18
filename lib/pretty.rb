# frozen_string_literal: true

# Convenience methods

module Pretty
  # Add n blank spaces
  def self.spacer(n) # rubocop:disable Naming/UncommunicativeMethodParamName
    repeat_chars(' ', n)
  end

  # txt = String of text
  def self.replace_special_chars_with_single_blank(txt)
    txt.gsub(/[^a-zA-Z]/, ' ')
  end

  # Alias, for convenience
  def self.blank_special_chars(txt)
    replace_special_chars_with_single_blank(txt)
  end

  # Initial caps - Brazilian Portuguese
  def self.initialcaps(name)
    name = name.mb_chars.titleize # First, titleize the name

    original_txt = ["Dell'", "D'", 'Da ', 'Das ', 'Do ', 'Dos ', 'De ', 'Del ', ' E ', ' Em ',
                    ' Entre ', ' A ', ' O ', ' Na ', ' La ', ' P/ ', ' No ', ' Como ', ' Com ',
                    ' Para ', ' Ao ', ' Por ']
    replacement_txt = ["dell'", "d'", 'da ', 'das ',  'do ', 'dos ', 'de ', 'del ', ' e ', ' em ',
                       ' entre ', ' a ', ' o ', ' na ', ' la ', ' para ', ' no ', ' como ',
                       ' com ', ' para ', ' ao ', ' por ']

    original_txt.each_with_index do |orig, i|
      next unless name.include? orig

      name.gsub!(orig, replacement_txt[i])
    end

    name
  end

  # Used for timestamping files mostly
  def self.right_now
    t = Time.now

    rnow = t.day.to_s + '_' + t.month.to_s + '_' + t.year.to_s + '_' + t.hour.to_s + 'h'

    if t.min < 10
      rnow += '0' # Add leading zero for minute, if applicable
    end

    rnow = rnow + t.min.to_s + '_'

    if t.sec < 10
      rnow += '0' # Add leading zero for minute, if applicable
    end

    rnow += t.sec.to_s

    rnow
  end

  # Retorna valor em reais - Brazilian reals
  def self.to_BRL(cents) # rubocop:disable Naming/MethodName
    Money.new(cents, 'BRL').format(separator: ',', delimiter: '.')
  end

  # Increase the text size by appending spaces to the left
  # Useful for Brazilian bankpayments
  def self.alphabetize(txt, field_width)
    spaces = field_width - txt.length

    spaces.times { txt += ' ' }

    txt[0..field_width - 1]
  end

  # Takes an integer and converts it to a string with zeros on the left up to the field width
  def self.zerofy_left(num, width)
    txt = ''

    size = Pretty.compute_size(num, width)

    if size <= width

      (width - size).times do
        txt += '0'
      end

      txt += num.to_s

    else

      puts I18n.t('error.invalid_size.too_small')

      width.times do
        txt += '?'
      end

    end

    txt
  end

  # Repeat a single character n times
  def self.repeat_chars(ch, n) # rubocop:disable Naming/UncommunicativeMethodParamName
    txt = ''
    n.times { txt += ch }

    txt
  end

  def self.compute_size(num, _width)
    size = if num != 0

             Math.log10(num.abs).floor + 1

           else

             1

           end

    size
  end

  # Methods below not tested yet

  # Returns female ordinal (in Portuguese)
  def self.ordinalize_feminine(txt)
    txt = I18n.t(txt.ordinalize)

    s = txt.length

    txt = txt[0..s - 2] + 'a'.html_safe if txt[s - 1] == 'o'

    txt
  end

  # i = index
  # usually inside a loop, e.g.
  # object_list.each_with_index |obj, i|
  def self.display_index_progress(i, small_interval, big_interval) # rubocop:disable Naming/UncommunicativeMethodParamName
    n = i + 1
    print n.to_s + ' ' if (i % small_interval).zero?
    puts if i.positive? && i % big_interval.zero?
  end
end
