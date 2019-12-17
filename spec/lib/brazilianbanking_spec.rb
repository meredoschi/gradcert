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

  it 'DEFAULT_LINE_SIZE is expected to be 240' do
    expect(Brazilianbanking::DEFAULT_LINE_SIZE).to eq(240)
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
end
