class Address < ActiveRecord::Base
  # http://www.sitepoint.com/complex-rails-forms-with-nested-attributes/

  # ------------------- References ------------------------

  belongs_to :bankbranch

  belongs_to :contact
  belongs_to :council
  belongs_to :course
  belongs_to :institution
  belongs_to :municipality
  belongs_to :program
  belongs_to :regionaloffice
  belongs_to :streetname

  has_paper_trail

  # 	attr_accessor	 :skip_validation  # http://stackoverflow.com/questions/5975047/how-to-validate-a-nested-model-object-based-on-the-state-of-the-parent-object

  # 	[:streetname_id, :municipality_id, :country_id].each do |ids|

  # RSPEC start

  validates :header, length: { maximum: 120 }, presence: true, if: :skip_validation
  validates :addr, presence: true, length: { maximum: 200 }, unless: :skip_validation
  validates :neighborhood, length: { maximum: 50 }, unless: :skip_validation
  validates :complement, length: { maximum: 50 }, unless: :skip_validation
  validates :postalcode, presence: true, length: { minimum: 5, maximum: 15 },
                         unless: :skip_validation
  validates :streetname_id, presence: true, unless: :skip_validation
  validates :municipality_id, presence: true, unless: :skip_validation

  validates_format_of :postalcode, with: /[0-9]{5}-[0-9]{3}/, unless: :skip_validation

  # 	scope :with_institution, lambda { joins(:institution) }

  # http://stackoverflow.com/questions/8620547/rails-scope-for-is-not-null-and-is-not-empty-blank
  scope :institution, -> { where.not(institution_id: nil) }

  scope :contact, -> { where.not(contact_id: nil) }

  # http://stackoverflow.com/questions/3784394/rails-3-combine-two-variables

  # CNAB - G032 - Bank payment
  def postal_code_prefix
    if postalcode.include? '-'

      postalcode.chomp.split('-').first.to_i

    else

      0

    end
  end

  def postal_code_suffix
    if postalcode.include? '-'

      postalcode.chomp.split('-').last

    else
      ' '

    end
  end

  def street_number
    streetnumber # aliased for convenience
  end

  def street
    if complement.present?

      [streetname.designation, addr, streetnum, complement].join(' ')

    else

      if streetname_id.present?

        [streetname.designation, addr, streetnum].join(' ')

      else

        [addr, streetnum].join(' ')

      end

    end
  end

  # CNAB - G032 - Brazilian bank payment (text file generation)
  def street_name
    [streetname.designation, addr].join(' ')
  end

  # Postal address
  # TDD
  def mailing
    street_name = [streetname.designation, addr].join(' ')
    street_addr = street_name + ', ' + streetnum.to_s + ' - ' + complement
    neighborhood = self.neighborhood

    city_and_state = municipality.name + ' (' + municipality.stateregion.state.abbreviation + ')'
    # Alternatively: use namewithstate (denormalized data) once this is properly implemented on municipalities controller

    postal_code = I18n.t('activerecord.attributes.address.postalcode') + ' ' + postalcode
    mailing_address = [street_addr, neighborhood, city_and_state, postal_code].join(' - ')
  end

  # International address(with country names)
  # TDD
  def correspondence
    country = municipality.stateregion.state.country.name

    [mailing, country].join(' - ')
  end

  def municipality_name
    municipality.name
  end

  def state_abbreviation
    municipality.stateregion.state.abbreviation
  end

  def skip_validation
    internal
  end
end
