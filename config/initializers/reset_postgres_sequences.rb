ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
# http://stackoverflow.com/questions/11068800/rails-auto-assigning-id-that-already-exists
# Marcelo

end