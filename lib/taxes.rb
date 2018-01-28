# To assist in (Brazilian) income tax and social security due calculations
module Taxes
  # Deprecated
  # Amount_before_tax is assumed to be Bigdecimal
  def self.social_security(bankpayment, amount_before_fee)
    taxation = bankpayment.payroll.taxation

    fee = amount_before_fee * taxation.socialsecurity

    fee /= 100.to_i

    fee
  end

  def self.personal_income(brackets, amount_before_tax, social_security_paid)
    @taxable_income = amount_before_tax.to_i - social_security_paid.to_i

    highest_bracket = brackets.highest.first # Unique value returned already (.first applied in order be able to access it as a single object)

    lowest_bracket = brackets.initial.first  # ditto

    @floor = lowest_bracket.start_cents

    @ceiling = highest_bracket.start_cents

    if @taxable_income < @floor

      @taxes = 0

    else

      if @taxable_income >= @ceiling

        @taxes = perform_calculation(@taxable_income, highest_bracket)

      else

        brackets.intermediate.each do |bracket|
          next unless within?(bracket.start_cents, bracket.finish_cents, @taxable_income)

          @taxes = perform_calculation(@taxable_income, bracket)
        end

      end

    end

    @taxes
  end

  def self.perform_calculation(pre_tax_amount, bracket)
    (pre_tax_amount * bracket.rate / 100) - bracket.deductible_cents
  end

  def self.within?(a, b, x)
    if x >= a && x <= b

      true

    else

      false

    end
  end
end
