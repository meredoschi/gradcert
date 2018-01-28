# http://www.acnenomor.com/2898194p1/how-to-have-the-scaffold-to-generate-another-partial-view-template-file
Rails.application.config.generators do |g|
  g.template_engine :all
  g.fallbacks[:all] = :erb # or haml/slim etc
end