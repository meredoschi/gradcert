# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :role do
    # Role(id: integer, name: string, management: boolean, teaching: boolean, clerical: boolean,
    # pap: boolean, medres: boolean, collaborator: boolean, student: boolean, itstaff: boolean)
    #  (id: integer, name: string, management: boolean, teaching: boolean, clerical: boolean,
    #  pap: boolean, medres: boolean, collaborator: boolean, student: boolean, itstaff: boolean)
    # name => ["Apoio administrativo", "Aprimorando", "Colaborador Pap", "Colaborador RM",
    # "Coordenador da comissão local", "Coordenador suplente da comissão local",
    # "Docente supervisor", "Residente", "Sistema"]

    #    sequence(:name) {|n| "#{I18n.t('definitions.role.names.pap.student')+' '+(n+1000).to_s}" }

    sequence(:name) do |n|
      (I18n.t('activerecord.models.student') + \
      ' ' + (n + rand(100_000)).to_s).to_s
    end

    trait :pap do
      pap { false }
      medres { false }
    end

    trait :medres do
      pap { false }
      medres { false }
    end

    # ***********************************
    trait :itstaff do
      sequence(:name) do |n|
        (I18n.t('definitions.role.names.itstaff') + \
         ' ' + (n + rand(100_000)).to_s).to_s
      end

      clerical { false }
      itstaff { true }
      management { false }
      student { false }
      teaching { false }
    end

    # "clerical role" (not systems admin)
    trait :clerical do
      sequence(:name) do |n|
        (I18n.t('definitions.role.names.pap.clerical') + \
         ' ' + (n + rand(100_000)).to_s).to_s
      end

      clerical { true }
      itstaff { false }
      management { false }
      student { false }
      teaching { false }
    end

    trait :pap_student do
      sequence(:name) do |n|
        (I18n.t('definitions.role.names.pap.student') + \
         ' ' + (n + rand(100_000)).to_s).to_s
      end

      pap { true }
      student { true }

      clerical { false }
      itstaff { false }
      management { false }
      teaching { false }
    end

    trait :clerical_and_it do
      clerical { true }
      itstaff { true }
      management { false }
      student { false }
      teaching { false }
    end

    #
    # names:
    #   pap:
    #     clerical: "Apoio administrativo"
    #     localmanager: "Coordenador da comissão local"
    #     localmanagersubstitute: "Coordenador suplente da comissão local"
    #     collaborator: "Colaborador do PAP"
    #     supervisor: "Docente supervisor"
    #     student: "Aprimorando"
    #   medres:
    #     clerical: "Apoio administrativo"
    #     localmanager: "Coordenador da comissão de residência médica"
    #     localmanagersubstitute: "Coordenador suplente da comissão de residência médica"
    #     collaborator: "Colaborador da RM"
    #     supervisor: "Preceptor"
    #     student: "Residente"
    #   itstaff: "Sistema"
    #

    # ***********************************

    #     trait :medres do
    #       kind "papmgr"
    #       description "Medical resident scholarship recipient"
    #     end
    #
    #     trait :papmgr do
    #       kind "papmgr"
    #       description "Pap manager"
    #     end
    #
    #     trait :medresmgr do
    #       kind "medresmgr"
    #       description "Medical Residency Manager"
    #     end
    #
    #     trait :paplocaladm do
    #       kind "paplocaladm"
    #       description "Pap local administrator"
    #     end
    #
    #     trait :medreslocaladm do
    #       kind "medreslocaladm"
    #       description "Medres local administrator"
    #     end
    #
    #     trait :medrescollaborator do
    #       kind "medrescollaborator"
    #       description "Medres collaborator (consultant from another institution)"
    #     end
    #
    #     trait :papcollaborator do
    #       kind "papcollaborator"
    #       description "Pap collaborator (consultant from another institution)"
    #     end
    #
    #     trait :admin do
    #       kind "admin"
    #       description "System administrator"
    #     end
    #
    #     trait :adminreadonly do
    #       kind "admin"
    #       description "Read-only (upper management, auditor access)"
    #     end
  end
end
