# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :permission do
    # => ["admin", "pap", "papcollaborator", "medrescollaborator", "paplocaladm",
    # "medreslocaladm", "medresmgr", "papmgr", "medres", "adminreadonly"]

    # ************* Default *************
    kind 'pap'
    description I18n.t('definitions.user_permission.description.pap')
    # ***********************************

    # student
    trait :pap do
      kind 'pap'
      description I18n.t('definitions.user_permission.description.pap')
    end

    trait :medres do
      kind 'medres'
      description I18n.t('definitions.user_permission.description.medres')
    end

    trait :papmgr do
      kind 'papmgr'
      description I18n.t('definitions.user_permission.description.papmgr')
    end

    trait :medresmgr do
      kind 'medresmgr'
      description I18n.t('definitions.user_permission.description.medresmgr')
    end

    trait :paplocaladm do
      kind 'paplocaladm'
      description I18n.t('definitions.user_permission.description.paplocaladm')
    end

    trait :medreslocaladm do
      kind 'medreslocaladm'
      description I18n.t('definitions.user_permission.description.medreslocaladm')
    end

    trait :medrescollaborator do
      kind 'medrescollaborator'
      description I18n.t('definitions.user_permission.description.medrescollaborator')
    end

    trait :papcollaborator do
      kind 'papcollaborator'
      description I18n.t('definitions.user_permission.description.papcollaborator')
    end

    trait :admin do
      kind 'admin'
      description I18n.t('definitions.user_permission.description.admin')
    end

    trait :adminreadonly do
      kind 'adminreadonly'
      description I18n.t('definitions.user_permission.description.adminreadonly')
    end
  end
end
