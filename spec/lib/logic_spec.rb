# frozen_string_literal: true

require 'rails_helper'

describe Logic, type: :helper do
  let(:range_a) { (1..5) } # Range (conceptually similar to a line segment in the number line)
  let(:range_b) { (7..9) }
  let(:range_c) { (-2..3) }
  let(:a) { 10 } # integers
  let(:b) { 20 }
  let(:x) { 15 }

  it '#intersect(range_a,range_b)' do
    intersection = nil
    lower_bound = [range_a.min, range_b.min].max
    upper_bound = [range_a.max, range_b.max].min
    intersection = (lower_bound..upper_bound) if upper_bound >= lower_bound

    expect(intersection).to eq(Logic.intersect(range_a, range_b))
  end

  #  Is a ≤ x ≤ b ?   (Given a ≤ b, by definition) # rubocop:disable Style/AsciiComments
  # rubocop:enable Style/AsciiComments
  it '#within?(a, b, x)' do
    is_within = ((x >= a) && (x <= b))

    expect(is_within).to eq(Logic.within?(a, b, x))
  end

  it '#intersection_size(range_a, range_b)' do
    res = nil # result
    intersection = Logic.intersect(range_a, range_b)
    res = intersection if intersection.present?
    expect(res).to eq(Logic.intersection_size(range_a, range_b))
  end
end
