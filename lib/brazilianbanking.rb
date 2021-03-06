# frozen_string_literal: true

# Methods pertinent to the Brazilian Financial System
module Brazilianbanking
  # Maxdigits = 8 for Banco do Brasil checking accounts
  # Maxdigits = 4 for Banco do Brasil branch numbers

  # Trim to n characters (from left to right)

  # e.g. Febraban (Brazilian banking federation) positional layout version 8.4 = 240 characters
  DEFAULT_LINE_SIZE = Settings.default_line_size

  def self.trim_text_to(txt, indx)
    txt[0..indx - 1]
  end

  def self.consistent_length(line)
    (line.length == DEFAULT_LINE_SIZE)
  end

  def self.inconsistent_length(line)
    !consistent_length(line)
  end

  # Useful when debugging line length consistency issues with CNAB files
  def self.checklength(line)
    if inconsistent_length(line)

      alert_msg = '***' + I18n.t('alert.different_length') + ' (' + line.length.to_s + \
                  ') ' + I18n.t('alert.than_expected') + '***'

      alert_msg + line

    else

      line

    end
  end

  def self.skew(correct_verification_digit)
    vd = correct_verification_digit[0] # 'defensive programming', make sure length is 1

    forcibly_incorrect_digit = if vd =~ /[0-8]/

                                 vd.next

                               else

                                 '0'

                               end

    forcibly_incorrect_digit
  end

  # December 2019 refactoring
  def self.compute_verification_sum(num, maxdigits)
    padded_num = Pretty.zerofy_left(num.to_i, maxdigits)

    verification_sum = 0

    (0..maxdigits + 1).each do |i|
      verification_sum += (maxdigits + 1 - i) * padded_num[i].to_i
    end

    verification_sum
  end

  def self.calculate_verification_digit(num, maxdigits)
    verification_sum = compute_verification_sum(num, maxdigits)

    remainder = verification_sum % 11

    checkdigit = 11 - remainder

    checkdigit = 'X' if checkdigit == 10

    checkdigit = '0' if checkdigit == 11

    checkdigit
  end

  # Primeiro digito verificador do CPF | First verification digit (Brazilian personal tax id)
  def self.cpf_dv1(cpf_prefix)
    verification_digit = 0

    (1..9).each do |k|
      verification_digit += k * cpf_prefix[k - 1].to_i
    end

    verification_digit = verification_digit % 11
    verification_digit = verification_digit % 10

    first_verification_digit = verification_digit.to_s

    first_verification_digit
  end

  # Segundo digito verificador do CPF | Second verification digit (Brazilian personal tax id)
  def self.cpf_dv2(cpf_prefix)
    verification_digit = 0

    (1..8).each do |k|
      verification_digit += k * cpf_prefix[k].to_i
    end

    verification_digit += 9 * Brazilianbanking.cpf_dv1(cpf_prefix).to_i # Chama DV1

    verification_digit = verification_digit % 11
    verification_digit = verification_digit % 10

    cpf_second_verification_digit = verification_digit.to_s

    cpf_second_verification_digit
  end

  # Takes 9 digit (character string)
  # Returns eleven zeros if incorrect length is provided

  def self.generate_cpf(cpf_prefix)
    cpf = if cpf_prefix.length == 9

            cpf_prefix + Brazilianbanking.cpf_dv1(cpf_prefix) + Brazilianbanking.cpf_dv2(cpf_prefix)

          else Pretty.repeat_chars('0', 11)
            #         else  '00000000000'
          end

    cpf
  end

  def self.compute_weighted_sum(nit_prefix)
    factors = [3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

    weighted_sum = 0

    (0..9).each do |i|
      weighted_sum += factors[i] * nit_prefix[i].to_i
    end

    weighted_sum
  end

  # Generates NIT - Brazilian Social Security Number - control digit
  def self.nit_dv(nit_prefix)
    weighted_sum = Brazilianbanking.compute_weighted_sum(nit_prefix)

    res = 11 - (weighted_sum % 11)

    nit_dv = if res < 10

               res.to_s

             else

               '0'

             end

    nit_dv
  end

  # Takes 10 digit (character string), returns eleven zeros if incorrect length is provided
  def self.generate_nit(nit_prefix)
    nit = if nit_prefix.length == 10

            nit_prefix + Brazilianbanking.nit_dv(nit_prefix)

          else '00000000000'

          end

    nit
  end

  # June 2017
  # Alias, for convenience
  def self.branch_verification_digit(num)
    calculate_verification_digit(num, Settings.max_length_for_bankbranch_code)
  end

  # June 2017
  # Alias, for convenience
  def self.account_verification_digit(num)
    calculate_verification_digit(num, Settings.max_length_for_bankaccount_number)
  end

  # Methods below are not tested yet
  # Methods below produce the Bankpayment File
  #
  #
  #
  # ----------------------------------------------------------------------

  # e.g. range_one=1..100, range_two=50..150, true
  def self.intersect(range_one, range_two)
    Logic.intersect(range_one, range_two)
  end
end
