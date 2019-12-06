# frozen_string_literal: true

# Localized

professional_area = Professionalarea.create(name: I18n.t('sample.area.life_sciences'), pap: true)
Professionalspecialty.create(name: I18n.t('sample.specialty.biology'),
                             pap: true, professionalarea_id: professional_area.id)

professional_area = Professionalarea.create(name: I18n.t('sample.area.health_care'), pap: true)
Professionalspecialty.create(name: I18n.t('sample.specialty.nursing'),
                             pap: true, professionalarea_id: professional_area.id)

professional_area = Professionalarea.create(name: I18n.t('sample.area.management'), pap: true)
Professionalspecialty.create(name: I18n.t('sample.specialty.business_administration'), pap: true, professionalarea_id: professional_area.id)
