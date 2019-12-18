# frozen_string_literal: true

require 'rails_helper'

describe Brazilianbanking, type: :helper do
  let(:correct_verification_digit) { '4' }
  let(:sample_text) { 'THIS IS A SAMPLE TEXT' }
  let(:indx) { 5 }

  # Febraban (Brazilian banking federation) positional layout 8.4 (line width = 240 characters)
  let(:line_with_two_hundred_and_forty_chars) do
    '1234567890123456789012345678901234567890'\
    '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'\
    '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'\
    '12345678901234567890'
  end

  let(:line_with_three_characters) { 'ABC' }

  let(:num) { '700' } # e.g. branch number (in string format)
  let(:maxdigits) { 4 } # e.g. brazilian bank branch
  # First 9 digits of the Brazilian tax identification number (in string format)
  let(:cpf_prefix) { '123456789' }

  it '#trim_text_to(sample_txt, indx)' do
    trimmed_txt = sample_text[0..indx - 1]
    expect(trimmed_txt).to eq(Brazilianbanking.trim_text_to(sample_text, indx))
  end

  it '#trim_text_to("HELLO WORLD", 5) returns "HELLO"' do
    trimmed_txt = 'HELLO'
    expect(trimmed_txt).to eq(Brazilianbanking.trim_text_to('HELLO WORLD', 5))
  end

  it 'has a DEFAULT_LINE_SIZE' do
    expect(Brazilianbanking::DEFAULT_LINE_SIZE).not_to be_nil
  end

  it 'DEFAULT_LINE_SIZE equals to Settings.default_line_size (should be 240 in Brazil)' do
    expect(Brazilianbanking::DEFAULT_LINE_SIZE).to eq(Settings.default_line_size)
  end

  it '#consistent_length(line_with_two_hundred_and_forty_chars)' do
    expect(line_with_two_hundred_and_forty_chars.length).to eq(Brazilianbanking::DEFAULT_LINE_SIZE)
  end

  it 'line with three characters do not equal the default size' do
    expect(line_with_three_characters.length).not_to eq(Brazilianbanking::DEFAULT_LINE_SIZE)
  end

  it '#inconsistent_length(sample_text) is the opposite of consistent' do
    expect(Brazilianbanking.inconsistent_length(sample_text)).to eq(!Brazilianbanking
      .consistent_length(sample_text))
  end

  # Used for debugging purposes (e.g. in the bankbranch factory)
  it '#skew(correct_verification_digit)' do
    vd = correct_verification_digit[0] # 'defensive programming', make sure length is 1

    forcibly_incorrect_digit = if vd =~ /[0-8]/

                                 vd.next

                               else

                                 '0' # "9" or "X" becomes "0"

                               end

    expect(forcibly_incorrect_digit).to eq(Brazilianbanking.skew(correct_verification_digit))
  end

  it '#calculate_verification_digit(num, maxdigits)' do
    verification_sum = Brazilianbanking.compute_verification_sum(num, maxdigits)

    remainder = verification_sum % 11

    checkdigit = 11 - remainder

    checkdigit = 'X' if checkdigit == 10

    checkdigit = '0' if checkdigit == 11

    expect(checkdigit).to eq(Brazilianbanking.calculate_verification_digit(num, maxdigits))
  end

  it '#compute_verification_sum(num, maxdigits)' do
    padded_num = Pretty.zerofy_left(num.to_i, maxdigits)

    verification_sum = 0

    (0..maxdigits + 1).each do |i|
      verification_sum += (maxdigits + 1 - i) * padded_num[i].to_i
    end

    expect(verification_sum).to eq(Brazilianbanking.compute_verification_sum(num, maxdigits))
  end

  # prefix = First 9 digits of the Brazilian tax identification number (in string format)
  it '#cpf_dv1(cpf_prefix)' do
    verification_digit = 0

    (1..9).each do |k|
      verification_digit += k * cpf_prefix[k - 1].to_i
    end

    verification_digit = verification_digit % 11
    verification_digit = verification_digit % 10

    cpf_first_verification_digit = verification_digit.to_s

    expect(cpf_first_verification_digit).to eq(Brazilianbanking.cpf_dv1(cpf_prefix))
  end

  it '#cpf_dv2(cpf_prefix)' do
    verification_digit = 0

    (1..8).each do |k|
      verification_digit += k * cpf_prefix[k].to_i
    end

    verification_digit += 9 * Brazilianbanking.cpf_dv1(cpf_prefix).to_i # Chama DV1

    verification_digit = verification_digit % 11
    verification_digit = verification_digit % 10

    cpf_second_verification_digit = verification_digit.to_s

    expect(cpf_second_verification_digit).to eq(Brazilianbanking.cpf_dv2(cpf_prefix))
  end

  it '#generate_cpf(cpf_prefix)' do
    cpf = if cpf_prefix.length == 9

            cpf_prefix + Brazilianbanking.cpf_dv1(cpf_prefix) + Brazilianbanking.cpf_dv2(cpf_prefix)

          else Pretty.repeat_chars('0', 11)
            #         else  '00000000000'
          end

    expect(cpf).to eq(Brazilianbanking.generate_cpf(cpf_prefix))
  end
end
