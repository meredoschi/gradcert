# frozen_string_literal: true

# Extra methods
module Extra
  # New method
  # base_amount = amount_cents (integer)
  # socialsecurity = bigdecimal
  # Result: bigdecimal (without cast) Ruby 2.3
  def self.calculate_social_security(base_amount, taxation)
    base_amount * taxation.socialsecurity / 100
  end
end
