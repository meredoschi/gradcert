# frozen_string_literal: true

# Methods pertinent to the Brazilian Financial System
module Brazilianbanking
  # Maxdigits = 8 for Banco do Brasil checking accounts
  # Maxdigits = 4 for Banco do Brasil branch numbers

  # Trim to n characters (from left to right)

  # e.g. Febraban (Brazilian banking federation) positional layout version 8.4 = 240 characters
  DEFAULT_LINE_SIZE = 240

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

  # Methods below are not tested yet

  def self.calculate_verification_digit(num, maxdigits)
    num = Pretty.zerofy_left(num.to_i, maxdigits)

    @verification_sum = 0

    (0..maxdigits + 1).each do |i|
      @verification_sum += (maxdigits + 1 - i) * num[i].to_i
    end

    @remainder = @verification_sum % 11

    @checkdigit = 11 - @remainder

    @checkdigit = 'X' if @checkdigit == 10

    @checkdigit = '0' if @checkdigit == 11

    @checkdigit
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

  # Methods below produce the Bankpayment File
  #
  #
  #
  # ----------------------------------------------------------------------

  # Takes 9 digit (character string)
  # Returns eleven zeros if incorrect length is provided

  def self.generate_cpf(prefix)
    cpf = if prefix.length == 9

            prefix + cpf_dv1(prefix) + cpf_dv2(prefix)

          else '00000000000'

          end

    cpf
  end

  # Takes 10 digit (character string)
  # Returns eleven zeros if incorrect length is provided
  def self.generate_nit(prefix)
    nit = if prefix.length == 10

            prefix + nit_dv(prefix)

          else '00000000000'

          end

    nit
  end

  # Generates NIT - Brazilian Social Security Number - control digit
  def self.nit_dv(str)
    factors = [3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

    weighted_sum = 0

    (0..9).each do |i|
      weighted_sum += factors[i] * str[i].to_i
    end

    res = 11 - (weighted_sum % 11)

    if res < 10

      return res.to_s

    else

      return '0'

    end
  end

  def self.cpf_dv1(str)
    v = 0

    (1..9).each do |k|
      v += k * str[k - 1].to_i
    end

    v = v % 11
    v = v % 10

    v.to_s
  end

  # e.g. range_one=1..100, range_two=50..150, true
  def self.intersect(range_one, range_two)
    @disjoint = 0

    if range_two.include?(range_one.first)
      @actual_start = range_one.first
    else
      @disjoint += 1
      @actual_start = range_two.first
    end

    if range_two.include?(range_one.last)
      @actual_finish = range_one.last
    else
      @disjoint += 1
      @actual_finish = range_two.last
    end

    if @disjoint == 2
      if range_one.first <= range_two.first && range_one.last >= range_two.last
        return p
      else
        return nil
      end
    else
      return (@actual_start..@actual_finish)
    end
  end

  # Segundo digito verificador do CPF

  def self.cpf_dv2(str)
    v = 0

    (1..8).each do |k|
      v += k * str[k].to_i
    end

    v += 9 * cpf_dv1(str).to_i # Chama DV1

    v = v % 11
    v = v % 10

    v.to_s
  end
end
