class RenameLeavetypeDays < ActiveRecord::Migration
  def change
    change_table :leavetypes do |t|
      t.rename :days, :setnumdays
      t.rename :maximumlimit, :maxnumdays
      t.rename :dayswithpaylimit, :dayspaidcap
    end
  end
end
