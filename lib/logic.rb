# frozen_string_literal: true

# Important logical verifications
module Logic
  def self.within?(a, b, x) # rubocop:disable Naming/MethodParameterName
    ((x >= a) && (x <= b))
  end

  # A,B are integer ranges
  def self.intersection_size(a, b) # rubocop:disable Naming/MethodParameterName
    res = nil # result
    intersection = intersect(a, b)
    res = intersection if intersection.present?
    res
  end

  # Returns the intersection of the two ranges, if it exists, otherwise nil.
  def self.intersect(range_a, range_b)
    intersection = nil
    lower_bound = [range_a.min, range_b.min].max
    upper_bound = [range_a.max, range_b.max].min
    intersection = (lower_bound..upper_bound) if upper_bound >= lower_bound

    intersection
  end
end
