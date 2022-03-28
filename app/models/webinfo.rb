# frozen_string_literal: true

# Web information
class Webinfo < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :contact, optional: true
  belongs_to :council, optional: true
  belongs_to :institution, optional: true
  belongs_to :regionaloffice, optional: true

  validate :site_url_without_protocol

  validates :site, length: { maximum: 150 }

  validates :email, length: { maximum: 100 }

  %i[facebook twitter other].each do |s|
    validates s, length: { maximum: 40 }
  end

  def site_url_without_protocol
    errors.add(:site, :incorrect) if site =~ %r{\Ahttps?://}
  end
end
