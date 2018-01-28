class Assessment < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :contact
  belongs_to :program
  belongs_to :profession

  has_many :programsituation, foreign_key: 'assessment_id'

  %i[contact_id program_id profession_id].each do |ids|
    validates ids, presence: true
  end

  def self.with_situation
    joins(:programsituation)
  end

  def self.without_situation
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: with_situation)
  end

  def self.pap
    joins(:program).merge(Program.pap)
    end

  def self.medres
    joins(:program).merge(Program.medres)
    end

  # retrieve assessments belonging to the current user

  def self.own(user)
    joins(assessment: :contact).merge(Contact.own(user))
  end

  def name_without_contact
    program_short_name + ' (' + profession_name + ')' + ' / ' + institution_short_name
  end

  def name
    contact_name + ': ' + program_short_name + ' (' + profession_name + ')' + ' / ' + institution_short_name

    # 	    [contact_name, program_short_name, profession_name, institution_short_name].join(" | ")
  end

  def short_name
    contact_short_name.join(' | ').program_short_name.join(' | ').institution_short_name.join(' | ').profession_short_name

    # 	    [contact_short_name, program_short_name, institution_short_name, profession_short_name].join(" | ")
  end

  def program_duration
    assessment.program.duration
    end

  def institution_name
    contact.user.institution.name
  end

  def institution_short_name
    institution_name.truncate(60)
  end

  def contact_name
    contact.name
    end

  def contact_short_name
    contact_name.truncate(50)
    end

  def profession_name
    profession.name
    end

  # used on index search (program) partial
  def program_name
    program.programname.name
    end

  def program_short_name
    program_name.truncate(60)
    end
end
