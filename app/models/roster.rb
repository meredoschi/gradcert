class Roster < ActiveRecord::Base
  has_paper_trail

  # ------------------- References ------------------------

  belongs_to :institution

  belongs_to :schoolterm

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  #	def self.default_scope
  # this notation prevents ambiguity
  #      order(name: :asc)
  # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  #	end

  # ***********************************************************************************************************************************
  %i[institution_id schoolterm_id dataentrystart dataentryfinish].each do |field|
    validates field, presence: true
  end

  validates :authorizedsupervisors, presence: true, numericality: { greater_than: 0 }

  def name
    institution.name + ' - ' + I18n.t('activerecord.models.schoolterm').capitalize + ' ' + schoolterm.name.downcase
   end

  # TDD
  def schedulerange
    dataentrystart..dataentryfinish # defined as a range
   end

  def schedule
    schedule = I18n.t('activerecord.attributes.roster.virtual.schedule').capitalize + ': '

    schedule += I18n.l(dataentrystart) + ' -> ' # textual representation

    schedule += I18n.l(dataentryfinish) # textual representation

    schedule
   end
end
