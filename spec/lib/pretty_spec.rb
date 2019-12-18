# frozen_string_literal: true

require 'rails_helper'

describe Pretty, type: :helper do
  let(:text) { 'Pão de queijo' }
  let(:original_txt) { 'Sample text' }
  let(:b) { 20 }
  let(:x) { 15 }
  let(:n) { 50 }   # number of repeats
  let(:ch) { '-' } # char to be repeated
  let(:num) { 123 }
  let(:width) { 8 } # Width to fill
  let(:cents) { 200 } # Used in Banking arithmetic
  let(:name) { "FULANO DOS TAIS" }

  # Used for timestamping files mostly
  it '#right_now' do
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

    expect(rnow).to eq(Pretty.right_now)

  end

  it '#replace_special_chars_with_single_blank(txt)' do
    filtered_text = text.gsub(/[^a-zA-Z]/, ' ')
    expect(filtered_text).to eq(Pretty.replace_special_chars_with_single_blank(text))
  end

  it '#to_BRL(cents)' do
    formatted_cents=Money.new(cents, 'BRL').format(separator: ',', delimiter: '.')
    expect(formatted_cents).to eq(Pretty.to_BRL(cents))
  end

  # Repeat a single character n times
  it '#repeat_chars(ch, n)' do
    txt = ''
    n.times { txt += ch }

    expect(txt).to eq(Pretty.repeat_chars(ch, n))
  end


  # Alias, for convenience
  it '#blank_special_chars(original_txt)' do
    processed_txt=Pretty.replace_special_chars_with_single_blank(original_txt)
    expect(processed_txt).to eq(Pretty.blank_special_chars(original_txt))
  end

  it '#spacer(n)' do
    spaces = Pretty.repeat_chars(' ', n)
    expect(spaces).to eq(Pretty.spacer(n))
  end

  it '#compute_size(num, width)' do

  size = if num != 0

           Math.log10(num.abs).floor + 1

         else

           1

         end

         expect(size).to eq(Pretty.compute_size(num, width))

  end

  # Takes an integer and converts it to a string with zeros on the left up to the field width
  it '#zerofy_left(num, width)' do
    txt = ''

    size = Pretty.compute_size(num, width)

    if (size <= width)

      (width - size).times do
        txt+='0'
      end

      txt += num.to_s

    else

      puts I18n.t('error.invalid_size.too_small')

      width.times do
        txt+='?'
      end

    end

    expect(txt).to eq(Pretty.zerofy_left(num, width))
  end

  # Increase the text size by appending spaces to the left
  # Useful for Brazilian bankpayments
  it '#alphabetize(original_txt, width)' do
    spaces = width - original_txt.length

    spaces.times { original_txt+=' ' }

    spaced_txt=original_txt[0..width - 1]

    expect(spaced_txt).to eq(Pretty.alphabetize(original_txt, width))
  end

  # Initial caps - Brazilian Portuguese
  it '#initialcaps(name)' do
    formatted_name = name.mb_chars.titleize # First, titleize the name

    original_txt = ["Dell'", "D'", 'Da ', 'Das ', 'Do ', 'Dos ', 'De ', 'Del ', ' E ', ' Em ',
                    ' Entre ', ' A ', ' O ', ' Na ', ' La ', ' P/ ', ' No ', ' Como ', ' Com ',
                    ' Para ', ' Ao ', ' Por ']
    replacement_txt = ["dell'", "d'", 'da ', 'das ',  'do ', 'dos ', 'de ', 'del ', ' e ', ' em ',
                       ' entre ', ' a ', ' o ', ' na ', ' la ', ' para ', ' no ', ' como ',
                       ' com ', ' para ', ' ao ', ' por ']

    original_txt.each_with_index do |orig, i|
      next unless formatted_name.include? orig

      formatted_name.gsub!(orig, replacement_txt[i])
    end

    expect(formatted_name).to eq(Pretty.initialcaps(name))
  end

end
