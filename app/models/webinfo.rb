class Webinfo < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :contact
  belongs_to :council
  belongs_to :institution
  belongs_to :regionaloffice

  validate :site_URL_is_clean

  validates :site, length: { maximum: 150 }

  validates :email, length: { maximum: 100 }

  %i[facebook twitter other].each do |s|
    validates s, length: { maximum: 40 }
  end

  def site_URL_is_clean
    #       errors.add(:url, 'digitada incorretamente.  Não é necessário iniciar com http://') if url =~ %r{\Ahttps?://}

    errors.add(:site, :incorrect) if site =~ %r{\Ahttps?://}
  end
end
