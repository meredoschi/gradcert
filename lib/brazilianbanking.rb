# Methods pertinent to the Brazilian Financial System
module Brazilianbanking
  # Maxdigits = 8 for Banco do Brasil checking accounts
  # Maxdigits = 4 for Banco do Brasil branch numbers

  # Trim to n characters (from left to right)

  def self.trim_text_to(txt, n)
    txt[0..n - 1]
  end

  def self.consistent_length(line)
    specified_length = 240

    (line.length == specified_length)
  end

  def self.inconsistent_length(line)
    !consistent_length(line)
  end

  def self.checklength(line)
    if inconsistent_length(line)

      line + ' Alerta!!! Comprimento diferente (' + line.length.to_s + ') do esperado. '

    else

      line

    end
  end

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
  # -------------------------------------------------------------------------------------------------

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

    for i in 0..9
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

  # a, b are Ruby ranges

  def self.intersect(a, b)
    @disjoint = 0

    if b.include?(a.first)
      @actual_start = a.first
    else
      @disjoint += 1
      @actual_start = b.first
      end

    if b.include?(a.last)
      @actual_finish = a.last
    else
      @disjoint += 1
      @actual_finish = b.last
      end

    if @disjoint == 2
      if a.first <= b.first && a.last >= b.last
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
