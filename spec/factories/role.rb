# This will guess the User class
FactoryBot.define do
  factory :role do

# Role(id: integer, name: string, management: boolean, teaching: boolean, clerical: boolean, created_at: datetime, updated_at: datetime, pap: boolean, medres: boolean, collaborator: boolean, student: boolean, itstaff: boolean)
#  (id: integer, name: string, management: boolean, teaching: boolean, clerical: boolean, created_at: datetime, updated_at: datetime, pap: boolean, medres: boolean, collaborator: boolean, student: boolean, itstaff: boolean)
# name => ["Apoio administrativo", "Aprimorando", "Colaborador Pap", "Colaborador RM", "Coordenador da comissão local", "Coordenador suplente da comissão local", "Docente supervisor", "Residente", "Sistema"]

#    sequence(:name) {|n| "#{I18n.t('definitions.role.names.pap.student')+' '+(n+1000).to_s}" }

    sequence(:name) {|n| "#{I18n.t('activerecord.models.student')+' '+(n+1000).to_s}" }

    trait :pap do
      pap true
      medres false
    end

    trait :medres do
      pap false
      medres true
    end

  # ***********************************
  trait :itstaff do

    sequence(:name) {|n| "#{I18n.t('definitions.role.names.itstaff')+' '+(n+1000).to_s}" }

    clerical false
    itstaff true
    management false
    student false
    teaching false

  end

  # i.e. Student
  trait :student do

    # Set to PAP (default)
    sequence(:name) {|n| "#{I18n.t('definitions.role.names.pap.student')+' '+(n+1000).to_s}" }

    student true
    management false
    teaching false
    clerical false
    collaborator false
    itstaff false

  end

  # "clerical role" (not systems admin)
  trait :clerical do

    sequence(:name) {|n| "#{I18n.t('definitions.role.names.pap.clerical')+' '+(n+1000).to_s}" }

    clerical true
    itstaff false
    management false
    student false
    teaching false

  end

  trait :clerical_and_it do

    clerical true
    itstaff true
    management false
    student false
    teaching false

  end

=begin

names:
  pap:
    clerical: "Apoio administrativo"
    localmanager: "Coordenador da comissão local"
    localmanagersubstitute: "Coordenador suplente da comissão local"
    collaborator: "Colaborador do PAP"
    supervisor: "Docente supervisor"
    student: "Aprimorando"
  medres:
    clerical: "Apoio administrativo"
    localmanager: "Coordenador da comissão de residência médica"
    localmanagersubstitute: "Coordenador suplente da comissão de residência médica"
    collaborator: "Colaborador da RM"
    supervisor: "Preceptor"
    student: "Residente"
  itstaff: "Sistema"



=end

  # ***********************************

=begin
    trait :medres do
      kind "papmgr"
      description "Medical resident scholarship recipient"
    end

    trait :papmgr do
      kind "papmgr"
      description "Pap manager"
    end

    trait :medresmgr do
      kind "medresmgr"
      description "Medical Residency Manager"
    end

    trait :paplocaladm do
      kind "paplocaladm"
      description "Pap local administrator"
    end

    trait :medreslocaladm do
      kind "medreslocaladm"
      description "Medres local administrator"
    end

    trait :medrescollaborator do
      kind "medrescollaborator"
      description "Medres collaborator (consultant from another institution)"
    end

    trait :papcollaborator do
      kind "papcollaborator"
      description "Pap collaborator (consultant from another institution)"
    end

    trait :admin do
      kind "admin"
      description "System administrator"
    end

    trait :adminreadonly do
      kind "admin"
      description "Read-only (upper management, auditor access)"
    end
=end

  end
end
