json.array!(@rosters) do |roster|
  json.extract! roster, :id, :institution_id, :schoolterm_id, :authorizedsupervisors, :dataentrystart, :dataentryfinish
  json.url roster_url(roster, format: :json)
end
