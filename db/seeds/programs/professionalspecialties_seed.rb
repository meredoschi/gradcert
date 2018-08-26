# frozen_string_literal: true

# Localized
Professionalspecialty.create!([
                                { name: I18n.t('sample.specialty.biology'), pap: true, professionalarea_id: 1 },
                                { name: I18n.t('sample.specialty.nursing'), pap: true, professionalarea_id: 2 },
                                { name: I18n.t('sample.specialty.business_administration'), professionalarea_id: 3 }
                              ])
