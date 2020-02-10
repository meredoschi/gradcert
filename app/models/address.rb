# frozen_string_literal: true

# Originally developed following Brazilian address conventions
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

  #   attr_accessor   :skip_validation  # http://stackoverflow.com/questions/5975047/how-to-validate-a-nested-model-object-based-on-the-state-of-the-parent-object

  #   [:streetname_id, :municipality_id, :country_id].each do |ids|

  # RSPEC start

  validates :header, length: { maximum: 120 }, presence: true, if: :skip_validation
  validates :addr, presence: true, length: { maximum: 200 }, unless: :skip_validation
  validates :neighborhood, length: { maximum: 50 }, unless: :skip_validation
  validates :complement, length: { maximum: 50 }, unless: :skip_validation
  validates :postalcode, presence: true, length: { minimum: 5, maximum: 15 },
                         unless: :skip_validation
  validates :streetname_id, presence: true, unless: :skip_validation
  validates :municipality_id, presence: true, unless: :skip_validation

  validates :postalcode, format: { with: /\A[0-9]{5}-[0-9]{3}\z/, unless: :skip_validation }

  #   scope :with_institution, lambda { joins(:institution) }

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
    streetnum # aliased for convenience
  end

  def with_complement
    [streetname.designation, addr, streetnum, complement].join(' ')
  end

  def with_complement_intl
    [streetnum, addr, streetname.designation, complement].join(' ')
  end

  def without_complement
    [streetname.designation, addr, streetnum].join(' ')
  end

  def without_complement_intl
    [streetnum, addr, streetname.designation].join(' ')
  end

  def street
    if complement.present?

      #      [streetname.designation, addr, streetnum, complement].join(' ')
      with_complement

    elsif streetname_id.present?

      without_complement

    else

      [addr, streetnum].join(' ')

    end
  end

  def street_intl
    if complement.present?
      with_complement_intl
    elsif streetname.id.present?
    else
      [streetnum, addr].join(' ')
    end
  end

  # CNAB - G032 - Brazilian bank payment (text file generation)
  def street_name
    [streetname.designation, addr].join(' ')
  end

  # Possible to do: use denormalized data if and when implemented in the municipalities controller
  def city_and_state
    state = municipality.stateregion.state
    municipality.name + ' (' + state.abbreviation + ')'
  end

  def post_code_i18n
    I18n.t('activerecord.attributes.address.postalcode') + ' ' + postalcode
  end

  def postal_addr
    street_name = [streetname.designation, addr].join(' ')
    street_name + ', ' + streetnum.to_s + ' - ' + complement
  end

  # Postal address
  # TDD
  def mailing
    street_addr = street_name + ', ' + streetnum.to_s + ' - ' + complement
    mailing_address = [street_addr, neighborhood, city_and_state, post_code_i18n].join(' - ')
    mailing_address
  end

  delegate :name, to: :municipality, prefix: true

  def state_abbreviation
    municipality.stateregion.state.abbreviation
  end

  def skip_validation
    internal
  end
end
