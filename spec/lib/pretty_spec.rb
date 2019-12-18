# frozen_string_literal: true

require 'rails_helper'

describe Pretty, type: :helper do
  # txt = string of text
  it '#blank_special_characters(txt)' do
    adjusted_text = txt

    expect(adjusted_text.to(eq Pretty.blank_special_characters(txt)))
  end
end
