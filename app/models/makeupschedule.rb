class Makeupschedule < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :registration

# 	has_many  :supervisor, :foreign_key => 'contact_id'

# -------------------------------------------------------

# ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

=begin
  validates :name, presence: true, uniqueness: {case_sensitive: false}, length:  { maximum: 200 }

  def self.default_scope
      # this notation prevents ambiguity
      order(name: :asc)
      # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

# ***********************************************************************************************************************************
=end

  def name
    registration.student.contact.name + ' | ' + I18n.l(start) + ' - ' + I18n.l(finish)
  end

  def previous_registration
    registration.previous
  end
end
