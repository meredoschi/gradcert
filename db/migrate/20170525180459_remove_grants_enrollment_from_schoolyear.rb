class RemoveGrantsEnrollmentFromSchoolyear < ActiveRecord::Migration[4.2]
  def change
    admissions_info = %w[grants maxenrollment scholarships grantsrequested]

    print 'Removing '

    admissions_info.each do |col_name|
      print col_name + ' '
      remove_column('schoolyears', col_name)
    end

    puts
  end
end
