# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permission, type: :model do
  let(:permission) { FactoryBot.create(:permission) }
  let(:user) { FactoryBot.create(:user, :pap) }

  context 'associations' do
    it { is_expected.to have_many(:user).dependent(:restrict_with_exception) }
  end

  context 'validations' do
  end

  context 'creation' do
    it '-can be created' do
      FactoryBot.create(:permission)
    end
  end

  context 'class methods' do
    it '#readonly' do
      read_only_permission = Permission.where(kind: 'adminreadonly')
      expect(read_only_permission).to eq(Permission.readonly)
    end

    it '#paplocalhr' do
      pap_local_hr_permission = Permission.where(kind: 'paplocaladm')
      expect(pap_local_hr_permission).to eq(Permission.paplocalhr)
    end

    # Refer to: users_helper.rb, retrieve_users_permissions_for(user)
    it '#regular' do
      regular_permission = Permission.where(kind: %i[pap medres])
      expect(regular_permission).to eq(Permission.regular)
    end

    it '#pap' do
      pap_permission = Permission.where(kind: %i[pap papcollaborator paplocaladm papmgr])
      expect(pap_permission).to eq(Permission.pap)
    end

    # Medical Residency
    it '#medres' do
      medres_permission = Permission
                          .where(kind: %i[medres medrescollaborator medreslocaladm medresmgr])
      expect(medres_permission).to eq(Permission.medres)
    end

    it '#paplocalrealm' do
      pap_local_realm = Permission.where(kind: %i[pap paplocaladm])
      #      pap_local_realm=Permission.where(kind: %i[pap papcollaborator paplocaladm])

      expect(pap_local_realm).to eq(Permission.paplocalrealm)
    end

    it '#paplocal' do
      pap_local_permission = Permission.paplocalrealm
      expect(pap_local_permission).to eq(Permission.paplocal)
    end

    it '#medreslocalrealm' do
      medres_local_realm = Permission.where(kind: %i[medres medreslocaladm])
      #      medres_local_realm=Permission.where(kind: %i[medres medrescollaborator medreslocaladm])

      expect(medres_local_realm).to eq(Permission.medreslocalrealm)
    end

    # Student or Collaborator
    it '#regular_or_collaborator' do
      regular_or_collaborator_permission = Permission
                                           .where(kind:
                                             %i[pap medres papcollaborator medrescollaborator])
      expect(regular_or_collaborator_permission).to eq(Permission.regular_or_collaborator)
    end

    # System administrators - Implemented as one responsible for all teaching areas
    it '#admin' do
      admin_permission = Permission.where(kind: %i[admin])
      expect(admin_permission).to eq(Permission.admin)
    end

    # Managers - oversee institutions in their sector (teaching area).  Examples: Pap, Medres
    it '#manager' do
      manager_permission = Permission.where(kind: %i[papmgr medresmgr])
      expect(manager_permission).to eq(Permission.manager)
    end

    # Local administrators
    it '#localadmin' do
      local_admin_permission = Permission.where(kind: %i[paplocaladm medreslocaladm])
      expect(local_admin_permission).to eq(Permission.localadmin)
    end

    it '#own_institution(user)' do
      users_own_institution = Permission.joins(user: :institution)
                                        .where('institutions.id = ?  ', user.institution_id).uniq
      expect(users_own_institution).to eq(Permission.own_institution(user))
    end
  end

  context 'instance methods' do
    # Permission belongs to Pap
    it '-pap?' do
      is_pap_permission = (permission.kind.include? 'pap')
      expect(is_pap_permission).to eq(permission.pap?)
    end

    # Permission belongs to Medres
    it '-medres?' do
      is_medres_permission = (permission.kind.include? 'medres')
      expect(is_medres_permission).to eq(permission.medres?)
    end

    # Is system administrator?
    it '-admin?' do
      is_admin_permission = (permission.kind.include? 'admin')
      expect(is_admin_permission).to eq(permission.admin?)
    end

    # Is local administrator?
    it '-localadmin?' do
      is_local_admin_permission = (permission.kind.include? 'localadmin')
      expect(is_local_admin_permission).to eq(permission.localadmin?)
    end

    # Manager
    it '-manager?' do
      is_manager_permission = (permission.kind.include? 'manager')
      expect(is_manager_permission).to eq(permission.manager?)
    end

    # Refined for registration season
    it '-regular?' do
      is_regular_permission = (permission.kind == 'pap' || permission.kind == 'medres')
      expect(is_regular_permission).to eq(permission.regular?)
    end

    it '-staff?' do
      is_staff = !permission.regular?
      expect(is_staff).to eq(permission.staff?)
    end
  end
end
