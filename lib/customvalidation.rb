# Custom validation
module CustomValidation
  class AllCharacters < ActiveModel::Validator
    def validate(record)
      if I18n.transliterate(record.name) =~ /[^[([(A-Z)|(a-z)]*\s?)+]]/
        record.errors.add(:name, :must_be_all_characters)
      end
    end
  end

  class NoDigits < ActiveModel::Validator
    def validate(record)
      unless (record.name =~ /[0-9]+/).nil?
        record.errors.add(:name, :may_not_contain_digits)
      end
    end
  end
end
