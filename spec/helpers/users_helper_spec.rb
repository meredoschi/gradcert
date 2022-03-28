# frozen_string_literal: true

# User helper methods
require 'rails_helper'

describe UsersHelper, type: :helper do
  let!(:user) { FactoryBot.create(:user, :pap) }
  let!(:undefined_user) { FactoryBot.create(:user) } # defaults to Pap

  let!(:medres_user) { FactoryBot.create(:user, :medres) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:adminreadonly) { FactoryBot.create(:user, :adminreadonly) }

  let!(:papmgr_user) { FactoryBot.create(:user, :papmgr) }
  let!(:paplocaladm_user) { FactoryBot.create(:user, :paplocaladm) }
  let!(:papcollaborator_user) { FactoryBot.create(:user, :papcollaborator) }

  let!(:medrescollaborator_user) { FactoryBot.create(:user, :medrescollaborator) }
  let!(:medresmgr_user) { FactoryBot.create(:user, :medresmgr) }
  let!(:medreslocaladm_user) { FactoryBot.create(:user, :medreslocaladm) }

  let!(:contact) { FactoryBot.create(:contact, :pap_student_role) }

  let(:at_least_one_institution_with_users) { Institution.with_users.count.positive? }
  let(:at_least_one_institution_with_users_viewable_by_read_only_role) { Institution.
    with_users_seen_by_readonly.count.positive? }
    let(:at_least_one_institution_with_pap_users) { Institution.with_pap_users.count.positive? }
    let(:at_least_one_institution_with_medres_users) { Institution.with_medres_users.count.positive? }

    let(:all_permissions) { Permission.all.joins(:user) }

    let(:relevant_to_read_only) { Permission.all.joins(:user) }

    # Pap
    let(:relevant_to_pap_local_admin) { Permission.own_institution(user).paplocal.joins(:user) }
    let(:relevant_to_pap_manager) { Permission.pap.joins(:user) }

    # Medical residency
    let(:relevant_to_medres_local_admin) { Permission.own_institution(user).medres.joins(:user) }
    let(:relevant_to_medres_manager) { Permission.medres.joins(:user) }

    # Future to do: Graduate certificate

    it '-contact_name?(user)' do
      contact_name_present = (user.contact.present? && user.contact.name.present?)
      expect(contact_name_present).to eq(helper.contact_name?(user))
    end

    context 'actual_users_permissions_for(user)' do

      it '-actual_users_permissions_for(admin)' do
        #    all_permissions = Permission.all.joins(:user)

        #    relevant_to_read_only = Permission.all.joins(:user)

        # Pap
        #    relevant_to_pap_local_admin = Permission.own_institution(user).paplocal.joins(:user)
        #    relevant_to_pap_manager = Permission.pap.joins(:user)

        # Medical residency
        #    relevant_to_medres_local_admin = Permission.own_institution(user).medres.joins(:user)
        #    relevant_to_medres_manager = Permission.medres.joins(:user)

        # Future to do: Graduate certificate

        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(admin) == 'admin' then all_permissions
        when permission_for(admin) == 'adminreadonly' then relevant_to_read_only
        when permission_for(admin) == 'papmgr' then relevant_to_pap_manager
        when permission_for(admin) == 'paplocaladm' then relevant_to_pap_local_admin
        when permission_for(admin) == 'medresmgr' then relevant_to_medres_manager
        when permission_for(admin) == 'medreslocaladm' then relevant_to_medres_local_admin
        end

        expect(profile).to eq(helper.actual_users_permissions_for(admin))
      end

      it '-actual_users_permissions_for(adminreadonly)' do

        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(adminreadonly) == 'admin' then all_permissions
        when permission_for(adminreadonly) == 'adminreadonly' then relevant_to_read_only
        when permission_for(adminreadonly) == 'papmgr' then relevant_to_pap_manager
        when permission_for(adminreadonly) == 'paplocaladm' then relevant_to_pap_local_admin
        when permission_for(adminreadonly) == 'medresmgr' then relevant_to_medres_manager
        when permission_for(adminreadonly) == 'medreslocaladm' then relevant_to_medres_local_admin
        end

        expect(profile).to eq(helper.actual_users_permissions_for(adminreadonly))
      end

      it '-actual_users_permissions_for(papmgr)' do

        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(papmgr_user) == 'admin' then all_permissions
        when permission_for(papmgr_user) == 'adminreadonly' then relevant_to_read_only
        when permission_for(papmgr_user) == 'papmgr' then relevant_to_pap_manager
        when permission_for(papmgr_user) == 'paplocaladm' then relevant_to_pap_local_admin
        when permission_for(papmgr_user) == 'medresmgr' then relevant_to_medres_manager
        when permission_for(papmgr_user) == 'medreslocaladm' then relevant_to_medres_local_admin
        end

        expect(profile).to eq(helper.actual_users_permissions_for(papmgr_user))
      end

      it '-actual_users_permissions_for(paplocaladm)' do

        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(paplocaladm_user) == 'admin' then all_permissions
        when permission_for(paplocaladm_user) == 'adminreadonly' then relevant_to_read_only
        when permission_for(paplocaladm_user) == 'papmgr' then relevant_to_pap_manager
        when permission_for(paplocaladm_user) == 'paplocaladm' then relevant_to_pap_local_admin
        when permission_for(paplocaladm_user) == 'medresmgr' then relevant_to_medres_manager
        when permission_for(paplocaladm_user) == 'medreslocaladm' then relevant_to_medres_local_admin
        end

        expect(profile).to eq(helper.actual_users_permissions_for(paplocaladm_user))
      end

      it '-actual_users_permissions_for(medresmgr)' do

        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(medresmgr_user) == 'admin' then all_permissions
        when permission_for(medresmgr_user) == 'adminreadonly' then relevant_to_read_only
        when permission_for(medresmgr_user) == 'papmgr' then relevant_to_pap_manager
        when permission_for(medresmgr_user) == 'paplocaladm' then relevant_to_pap_local_admin
        when permission_for(medresmgr_user) == 'medresmgr' then relevant_to_medres_manager
        when permission_for(medresmgr_user) == 'medreslocaladm' then relevant_to_medres_local_admin
        end

        expect(profile).to eq(helper.actual_users_permissions_for(medresmgr_user))
      end

      it '-actual_users_permissions_for(medreslocaladm)' do

        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(medreslocaladm_user) == 'admin' then all_permissions
        when permission_for(medreslocaladm_user) == 'adminreadonly' then relevant_to_read_only
        when permission_for(medreslocaladm_user) == 'papmgr' then relevant_to_pap_manager
        when permission_for(medreslocaladm_user) == 'paplocaladm' then relevant_to_pap_local_admin
        when permission_for(medreslocaladm_user) == 'medresmgr' then relevant_to_medres_manager
        when permission_for(medreslocaladm_user) == 'medreslocaladm' then relevant_to_medres_local_admin
        end

        expect(profile).to eq(helper.actual_users_permissions_for(medreslocaladm_user))
      end

    end

    context 'defined in application permissions with the same name' do
      # Already defined in application permissions helper (included here for completeness)
      it '-permission_for(user)' do
        user_permission_kind = user.permission.kind
        expect(user_permission_kind).to eq(helper.permission_for(user))
      end

      # Already defined in application permissions helper (included here for completeness)
      it '-profile(user)' do
        user_description = user.permission.description
        safe_txt = safe_join([user_description])
        expect(safe_txt).to eq(helper.profile(user))
      end
    end

    context 'show permission for user (various kinds)' do
      context 'Undefined, permission not set' do
        # Regular user (PAP)
        it '-show_permission_for(undefined_user)' do
          desc = 'definitions.user_permission.description.'

          undefined_user.permission.kind = nil
          undefined_user.save

          description = if permission_for(undefined_user) == 'admin'
            I18n.t(desc + 'admin')
          elsif permission_for(undefined_user) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(undefined_user) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(undefined_user) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(undefined_user) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(undefined_user) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(undefined_user) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(undefined_user) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(undefined_user) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(undefined_user) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(undefined_user))
        end
      end

      context 'PAP' do
        # Regular user (PAP)
        it '-show_permission_for(user) - Pap' do
          desc = 'definitions.user_permission.description.'

          description = if permission_for(user) == 'admin'
            I18n.t(desc + 'admin')
          elsif permission_for(user) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(user) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(user) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(user) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(user) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(user) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(user) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(user) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(user) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(user))
        end

        # Pap collaborator
        it '-show_permission_for(papcollaborator_user)' do
          desc = 'definitions.user_permission.description.'

          description = if permission_for(papcollaborator_user) == 'admin'
            I18n.t(desc + 'admin')
          elsif permission_for(papcollaborator_user) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(papcollaborator_user) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(papcollaborator_user) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(papcollaborator_user) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(papcollaborator_user) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(papcollaborator_user) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(papcollaborator_user) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(papcollaborator_user) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(papcollaborator_user) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(papcollaborator_user))
        end

        # Pap manager
        it '-show_permission_for(papmgr_user)' do
          desc = 'definitions.user_permission.description.'

          description = if permission_for(papmgr_user) == 'admin'
            I18n.t(desc + 'admin')
          elsif permission_for(papmgr_user) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(papmgr_user) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(papmgr_user) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(papmgr_user) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(papmgr_user) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(papmgr_user) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(papmgr_user) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(papmgr_user) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(papmgr_user) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(papmgr_user))
        end

        # Pap local administrator
        it '-show_permission_for(paplocaladm_user)' do
          desc = 'definitions.user_permission.description.'

          description = if permission_for(paplocaladm_user) == 'admin'
            I18n.t(desc + 'admin')
          elsif permission_for(paplocaladm_user) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(paplocaladm_user) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(paplocaladm_user) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(paplocaladm_user) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(paplocaladm_user) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(paplocaladm_user) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(paplocaladm_user) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(paplocaladm_user) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(paplocaladm_user) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(paplocaladm_user))
        end
      end

      context 'Medical residency' do
        # Regular user (medres)
        it '-show_permission_for(medres_user)' do
          desc = 'definitions.user_permission.description.'

          description = if permission_for(medres_user) == 'admin'
            I18n.t(desc + 'admin')
          elsif permission_for(medres_user) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(medres_user) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(medres_user) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(medres_user) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(medres_user) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(medres_user) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(medres_user) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(medres_user) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(medres_user) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(medres_user))
        end

        it '-show_permission_for(medrescollaborator_user)' do
          desc = 'definitions.user_permission.description.'

          description = if permission_for(medrescollaborator_user) == 'admin'
            I18n.t(desc + 'admin')
          elsif permission_for(medrescollaborator_user) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(medrescollaborator_user) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(medrescollaborator_user) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(medrescollaborator_user) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(medrescollaborator_user) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(medrescollaborator_user) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(medrescollaborator_user) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(medrescollaborator_user) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(medrescollaborator_user) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(medrescollaborator_user))
        end

        # Medical residency manager
        it '-show_permission_for(medresmgr_user)' do
          desc = 'definitions.user_permission.description.'

          description = if permission_for(medresmgr_user) == 'admin'
            I18n.t(desc + 'admin')
          elsif permission_for(medresmgr_user) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(medresmgr_user) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(medresmgr_user) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(medresmgr_user) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(medresmgr_user) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(medresmgr_user) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(medresmgr_user) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(medresmgr_user) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(medresmgr_user) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(medresmgr_user))
        end

        # Medical residency local administrator
        it '-show_permission_for(medreslocaladm_user)' do
          desc = 'definitions.user_permission.description.'

          description = if permission_for(medreslocaladm_user) == 'admin'
            I18n.t(desc + 'admin')
          elsif permission_for(medreslocaladm_user) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(medreslocaladm_user) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(medreslocaladm_user) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(medreslocaladm_user) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(medreslocaladm_user) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(medreslocaladm_user) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(medreslocaladm_user) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(medreslocaladm_user) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(medreslocaladm_user) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(medreslocaladm_user))
        end
      end

      context 'Read only (upper management, auditors, etc)' do
        # System admin
        it '-show_permission_for(adminreadonly)' do
          desc = 'definitions.user_permission.description.'

          description = if permission_for(adminreadonly) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          elsif permission_for(adminreadonly) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(adminreadonly) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(adminreadonly) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(adminreadonly) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(adminreadonly) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(adminreadonly) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(adminreadonly) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(adminreadonly) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(adminreadonly) == 'adminreadonlyreadonly'
            I18n.t(desc + 'adminreadonlyreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(adminreadonly))
        end
      end

      context 'IT - System admin' do
        # System admin
        it '-show_permission_for(admin)' do
          desc = 'definitions.user_permission.description.'

          description = if permission_for(admin) == 'admin'
            I18n.t(desc + 'admin')
          elsif permission_for(admin) == 'pap'
            I18n.t(desc + 'pap')
          elsif permission_for(admin) == 'papcollaborator'
            I18n.t(desc + 'papcollaborator')
          elsif permission_for(admin) == 'paplocaladm'
            I18n.t(desc + 'paplocaladm')
          elsif permission_for(admin) == 'papmgr'
            I18n.t(desc + 'papmgr')
          elsif permission_for(admin) == 'medres'
            I18n.t(desc + 'medres')
          elsif permission_for(admin) == 'medrescollaborator'
            I18n.t(desc + 'medrescollaborator')
          elsif permission_for(admin) == 'medreslocaladm'
            I18n.t(desc + 'medreslocaladm')
          elsif permission_for(admin) == 'medresmgr'
            I18n.t(desc + 'medresmgr')
          elsif permission_for(admin) == 'adminreadonly'
            I18n.t(desc + 'adminreadonly')
          else I18n.t('undefined_value')
          end

          expect(safe_join([description])).to eq(helper.show_permission_for(admin))
        end
      end
    end

    it '-profileflag(user)' do
      user_profile_flag = safe_join([user.permission.kind])
      expect(user_profile_flag).to eq(helper.profileflag(user))
    end

    # http://stackoverflow.com/questions/12361631/rendering-partials-from-a-helper-method
    #
    # Revised -------------------------------------------
    #
    # Does not include local admins, which are handled separately using an if in the view
    # def institution_with_users_exists_for(user)

    it '-institution_with_users_exists_for(user)' do
      #  at_least_one_institution_with_users = Institution.with_users.count.positive?
      #  at_least_one_institution_with_users_viewable_by_read_only_role = \
      #    Institution.with_users_seen_by_readonly.count.positive?
      #  at_least_one_institution_with_pap_users = Institution.with_pap_users.count.positive?
      #  at_least_one_institution_with_medres_users = Institution.with_medres_users.count.positive?

      profile = if permission_for(user) == 'admin' && at_least_one_institution_with_users then true
      elsif permission_for(user) == 'adminreadonly' && \
        at_least_one_institution_with_users_viewable_by_read_only_role then true
      elsif permission_for(user) == 'papmgr' && \
        at_least_one_institution_with_pap_users then true
      elsif permission_for(user) == 'medresmgr' && \
        at_least_one_institution_with_medres_users then true

      end

      expect(profile).to eq(helper.institution_with_users_exists_for(user))
    end

    # Includes local admins (i.e. Permissions for users from own institution)
    it '-retrieve_users_permissions_for(user)' do
      profile = case # rubocop:disable Style/EmptyCaseCondition

      when permission_for(user) == 'admin' then return Permission.all
      when permission_for(user) == 'adminreadonly' then return Permission.readonly
      when permission_for(user) == 'papmgr' then return Permission.pap
      when permission_for(user) == 'medresmgr' then return Permission.medres
      when permission_for(user) == 'medreslocaladm' then return Permission.medreslocalrealm
      when permission_for(user) == 'paplocaladm' then return Permission.paplocalrealm

      end
      expect(profile).to eq(helper.retrieve_users_permissions_for(user))
    end

    # new context

    context 'permissions joins(:user)' do

      it 'retrieve_active_users_permissions_for(user)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(user) == 'admin' then Permission.all.joins(:user).distinct
        when permission_for(user) == 'adminreadonly' then Permission.readonly
          .joins(:user).distinct
        when permission_for(user) == 'papmgr' then Permission.pap.joins(:user).distinct
        when permission_for(user) == 'medresmgr' then Permission.medres.joins(:user).distinct
        when permission_for(user) == 'medreslocaladm' then Permission
          .own_institution(user).medres.joins(:user).distinct
        when permission_for(user) == 'paplocaladm' then Permission
          .own_institution(user).paplocal.joins(:user).distinct
        end

        expect(profile).to eq(helper.retrieve_active_users_permissions_for(user))
      end

      it 'retrieve_active_users_permissions_for(admin)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(admin) == 'admin' then Permission.all.joins(:user).distinct
        when permission_for(admin) == 'adminreadonly' then Permission.readonly
          .joins(:user).distinct
        when permission_for(admin) == 'papmgr' then Permission.pap.joins(:user).distinct
        when permission_for(admin) == 'medresmgr' then Permission.medres.joins(:user).distinct
        when permission_for(admin) == 'medreslocaladm' then Permission
          .own_institution(admin).medres.joins(:user).distinct
        when permission_for(admin) == 'paplocaladm' then Permission
          .own_institution(admin).paplocal.joins(:user).distinct
        end

        expect(profile).to eq(helper.retrieve_active_users_permissions_for(admin))
      end

      it 'retrieve_active_users_permissions_for(adminreadonly)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(adminreadonly) == 'admin' then Permission.all.joins(:user).distinct
        when permission_for(adminreadonly) == 'adminreadonly' then Permission.readonly
          .joins(:user).distinct
        when permission_for(adminreadonly) == 'papmgr' then Permission.pap.joins(:user).distinct
        when permission_for(adminreadonly) == 'medresmgr' then Permission.medres.joins(:user).distinct
        when permission_for(adminreadonly) == 'medreslocaladm' then Permission
          .own_institution(adminreadonly).medres.joins(:user).distinct
        when permission_for(adminreadonly) == 'paplocaladm' then Permission
          .own_institution(adminreadonly).paplocal.joins(:user).distinct
        end

        expect(profile).to eq(helper.retrieve_active_users_permissions_for(adminreadonly))
      end

      it 'retrieve_active_users_permissions_for(paplocaladm)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(paplocaladm_user) == 'admin' then Permission.all.joins(:user).distinct
        when permission_for(paplocaladm_user) == 'adminreadonly' then Permission.readonly
          .joins(:user).distinct
        when permission_for(paplocaladm_user) == 'papmgr' then Permission.pap.joins(:user).distinct
        when permission_for(paplocaladm_user) == 'medresmgr' then Permission.medres.joins(:user).distinct
        when permission_for(paplocaladm_user) == 'medreslocaladm' then Permission
          .own_institution(paplocaladm_user).medres.joins(:user).distinct
        when permission_for(paplocaladm_user) == 'paplocaladm' then Permission
          .own_institution(paplocaladm_user).paplocal.joins(:user).distinct
        end

        expect(profile).to eq(helper.retrieve_active_users_permissions_for(paplocaladm_user))
      end

      it 'retrieve_active_users_permissions_for(papmgr)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(papmgr_user) == 'admin' then Permission.all.joins(:user).distinct
        when permission_for(papmgr_user) == 'adminreadonly' then Permission.readonly
          .joins(:user).distinct
        when permission_for(papmgr_user) == 'papmgr' then Permission.pap.joins(:user).distinct
        when permission_for(papmgr_user) == 'medresmgr' then Permission.medres.joins(:user).distinct
        when permission_for(papmgr_user) == 'medreslocaladm' then Permission
          .own_institution(papmgr_user).medres.joins(:user).distinct
        when permission_for(papmgr_user) == 'paplocaladm' then Permission
          .own_institution(papmgr_user).paplocal.joins(:user).distinct
        end

        expect(profile).to eq(helper.retrieve_active_users_permissions_for(papmgr_user))
      end

      it 'retrieve_active_users_permissions_for(medreslocaladm)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(medreslocaladm_user) == 'admin' then Permission.all.joins(:user).distinct
        when permission_for(medreslocaladm_user) == 'adminreadonly' then Permission.readonly
          .joins(:user).distinct
        when permission_for(medreslocaladm_user) == 'papmgr' then Permission.pap.joins(:user).distinct
        when permission_for(medreslocaladm_user) == 'medresmgr' then Permission.medres.joins(:user).distinct
        when permission_for(medreslocaladm_user) == 'medreslocaladm' then Permission
          .own_institution(medreslocaladm_user).medres.joins(:user).distinct
        when permission_for(medreslocaladm_user) == 'paplocaladm' then Permission
          .own_institution(medreslocaladm_user).paplocal.joins(:user).distinct
        end

        expect(profile).to eq(helper.retrieve_active_users_permissions_for(medreslocaladm_user))
      end

      it 'retrieve_active_users_permissions_for(medresmgr)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(medresmgr_user) == 'admin' then Permission.all.joins(:user).distinct
        when permission_for(medresmgr_user) == 'adminreadonly' then  Permission.readonly
          .joins(:user).distinct
        when permission_for(medresmgr_user) == 'papmgr' then Permission.pap.joins(:user).distinct
        when permission_for(medresmgr_user) == 'medresmgr' then Permission.medres.joins(:user).distinct
        when permission_for(medresmgr_user) == 'medreslocaladm' then Permission
          .own_institution(medresmgr_user).medres.joins(:user).distinct
        when permission_for(medresmgr_user) == 'paplocaladm' then Permission
          .own_institution(medresmgr_user).paplocal.joins(:user).distinct
        end

        expect(profile).to eq(helper.retrieve_active_users_permissions_for(medresmgr_user))
      end

    end

    context 'retrieve_users_permissions_for(user) (all possible permissions even if no one with that one is yet registered in the database)' do

      it 'retrieve_users_permissions_for(user)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(user) == 'admin' then Permission.all
        when permission_for(user) == 'adminreadonly' then Permission.readonly

        when permission_for(user) == 'papmgr' then Permission.pap
        when permission_for(user) == 'medresmgr' then Permission.medres
        when permission_for(user) == 'medreslocaladm' then Permission
          .own_institution(user).medres
        when permission_for(user) == 'paplocaladm' then Permission
          .own_institution(user).paplocal
        end

        expect(profile).to eq(helper.retrieve_users_permissions_for(user))
      end

      it 'retrieve_users_permissions_for(admin)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(admin) == 'admin' then Permission.all
        when permission_for(admin) == 'adminreadonly' then Permission.readonly

        when permission_for(admin) == 'papmgr' then Permission.pap
        when permission_for(admin) == 'medresmgr' then Permission.medres
        when permission_for(admin) == 'medreslocaladm' then Permission
          .own_institution(admin).medres
        when permission_for(admin) == 'paplocaladm' then Permission
          .own_institution(admin).paplocal
        end

        expect(profile).to eq(helper.retrieve_users_permissions_for(admin))
      end

      it 'retrieve_users_permissions_for(adminreadonly)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(adminreadonly) == 'admin' then Permission.all
        when permission_for(adminreadonly) == 'adminreadonly' then Permission.readonly

        when permission_for(adminreadonly) == 'papmgr' then Permission.pap
        when permission_for(adminreadonly) == 'medresmgr' then Permission.medres
        when permission_for(adminreadonly) == 'medreslocaladm' then Permission
          .own_institution(adminreadonly).medres
        when permission_for(adminreadonly) == 'paplocaladm' then Permission
          .own_institution(adminreadonly).paplocal
        end

        expect(profile).to eq(helper.retrieve_users_permissions_for(adminreadonly))
      end

      it 'retrieve_users_permissions_for(paplocaladm)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(paplocaladm_user) == 'admin' then Permission.all
        when permission_for(paplocaladm_user) == 'adminreadonly' then Permission.readonly

        when permission_for(paplocaladm_user) == 'papmgr' then Permission.pap
        when permission_for(paplocaladm_user) == 'medresmgr' then Permission.medres
        when permission_for(paplocaladm_user) == 'medreslocaladm' then Permission
          .own_institution(paplocaladm_user).medres
        when permission_for(paplocaladm_user) == 'paplocaladm' then Permission
          .own_institution(paplocaladm_user).paplocal
        end

        expect(profile).to eq(helper.retrieve_users_permissions_for(paplocaladm_user))
      end

      it 'retrieve_users_permissions_for(papmgr)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(papmgr_user) == 'admin' then Permission.all
        when permission_for(papmgr_user) == 'adminreadonly' then Permission.readonly

        when permission_for(papmgr_user) == 'papmgr' then Permission.pap
        when permission_for(papmgr_user) == 'medresmgr' then Permission.medres
        when permission_for(papmgr_user) == 'medreslocaladm' then Permission
          .own_institution(papmgr_user).medres
        when permission_for(papmgr_user) == 'paplocaladm' then Permission
          .own_institution(papmgr_user).paplocal
        end

        expect(profile).to eq(helper.retrieve_users_permissions_for(papmgr_user))
      end

      it 'retrieve_users_permissions_for(medreslocaladm)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(medreslocaladm_user) == 'admin' then Permission.all
        when permission_for(medreslocaladm_user) == 'adminreadonly' then Permission.readonly

        when permission_for(medreslocaladm_user) == 'papmgr' then Permission.pap
        when permission_for(medreslocaladm_user) == 'medresmgr' then Permission.medres
        when permission_for(medreslocaladm_user) == 'medreslocaladm' then Permission
          .own_institution(medreslocaladm_user).medres
        when permission_for(medreslocaladm_user) == 'paplocaladm' then Permission
          .own_institution(medreslocaladm_user).paplocal
        end

        expect(profile).to eq(helper.retrieve_users_permissions_for(medreslocaladm_user))
      end

      it 'retrieve_users_permissions_for(medresmgr)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(medresmgr_user) == 'admin' then Permission.all
        when permission_for(medresmgr_user) == 'adminreadonly' then  Permission.readonly

        when permission_for(medresmgr_user) == 'papmgr' then Permission.pap
        when permission_for(medresmgr_user) == 'medresmgr' then Permission.medres
        when permission_for(medresmgr_user) == 'medreslocaladm' then Permission
          .own_institution(medresmgr_user).medres
        when permission_for(medresmgr_user) == 'paplocaladm' then Permission
          .own_institution(medresmgr_user).paplocal
        end

        expect(profile).to eq(helper.retrieve_users_permissions_for(medresmgr_user))
      end

    end

    # end context

    context 'institution_with_users_exists_for(user)' do

      # Does not include local admins, which are handled separately using an if in the view
      it '-institution_with_users_exists_for(admin)' do
        #    at_least_one_institution_with_users = Institution.with_users.count.positive?
        #    at_least_one_institution_with_users_viewable_by_read_only_role = \
        #      Institution.with_users_seen_by_readonly.count.positive?
        #    at_least_one_institution_with_pap_users = Institution.with_pap_users.count.positive?
        #    at_least_one_institution_with_medres_users = Institution.with_medres_users.count.positive?

        profile = if permission_for(admin) == 'admin' && at_least_one_institution_with_users then true
        elsif permission_for(admin) == 'adminreadonly' && \
          at_least_one_institution_with_users_viewable_by_read_only_role then true
        elsif permission_for(admin) == 'papmgr' && \
          at_least_one_institution_with_pap_users then true
        elsif permission_for(admin) == 'medresmgr' && \
          at_least_one_institution_with_medres_users then true

        end

        expect(profile).to eq(helper.institution_with_users_exists_for(admin))

      end

      it '-institution_with_users_exists_for(adminreadonly)' do
        profile = if permission_for(adminreadonly) == 'admin' && at_least_one_institution_with_users then true
        elsif permission_for(adminreadonly) == 'adminreadonly' && \
          at_least_one_institution_with_users_viewable_by_read_only_role then true
        elsif permission_for(adminreadonly) == 'papmgr' && \
          at_least_one_institution_with_pap_users then true
        elsif permission_for(adminreadonly) == 'medresmgr' && \
          at_least_one_institution_with_medres_users then true

        end

        expect(profile).to eq(helper.institution_with_users_exists_for(adminreadonly))

      end

      it '-institution_with_users_exists_for(papmgr_user)' do
        profile = if permission_for(papmgr_user) == 'admin' && at_least_one_institution_with_users then true
        elsif permission_for(papmgr_user) == 'adminreadonly' && \
          at_least_one_institution_with_users_viewable_by_read_only_role then true
        elsif permission_for(papmgr_user) == 'papmgr' && \
          at_least_one_institution_with_pap_users then true
        elsif permission_for(papmgr_user) == 'medresmgr' && \
          at_least_one_institution_with_medres_users then true

        end

        expect(profile).to eq(helper.institution_with_users_exists_for(papmgr_user))

      end

      it '-institution_with_users_exists_for(medresmgr_user)' do
        profile = if permission_for(medresmgr_user) == 'admin' && at_least_one_institution_with_users then true
        elsif permission_for(medresmgr_user) == 'adminreadonly' && \
          at_least_one_institution_with_users_viewable_by_read_only_role then true
        elsif permission_for(medresmgr_user) == 'papmgr' && \
          at_least_one_institution_with_pap_users then true
        elsif permission_for(medresmgr_user) == 'medresmgr' && \
          at_least_one_institution_with_medres_users then true

        end

        expect(profile).to eq(helper.institution_with_users_exists_for(medresmgr_user))


      end
    end


    context 'retrieve_institution_with_users_for(user)' do

      it '-retrieve_institution_with_users_for(admin)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(admin) == 'admin' then Institution.with_users.to_a.uniq
        when permission_for(admin) == 'adminreadonly' then Institution.with_users_seen_by_readonly.to_a.uniq
        when permission_for(admin) == 'papmgr' then Institution.with_pap_users.to_a.uniq
        when permission_for(admin) == 'medresmgr' then Institution.with_medres_users.to_a.uniq
        end

        expect(profile).to eq(helper.retrieve_institution_with_users_for(admin))

      end

      it '-retrieve_institution_with_users_for(adminreadonly)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(adminreadonly) == 'admin' then Institution.with_users.to_a.uniq
        when permission_for(adminreadonly) == 'adminreadonly' then Institution.with_users_seen_by_readonly.to_a.uniq
        when permission_for(adminreadonly) == 'papmgr' then Institution.with_pap_users.to_a.uniq
        when permission_for(adminreadonly) == 'medresmgr' then Institution.with_medres_users.to_a.uniq
        end

        expect(profile).to eq(helper.retrieve_institution_with_users_for(adminreadonly))

      end

      it '-retrieve_institution_with_users_for(papmgr)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(papmgr_user) == 'admin' then Institution.with_users.to_a.uniq
        when permission_for(papmgr_user) == 'adminreadonly' then Institution.with_users_seen_by_readonly.to_a.uniq
        when permission_for(papmgr_user) == 'papmgr' then Institution.with_pap_users.to_a.uniq
        when permission_for(papmgr_user) == 'medresmgr' then Institution.with_medres_users.to_a.uniq
        end

        expect(profile).to eq(helper.retrieve_institution_with_users_for(papmgr_user))

      end

      it '-retrieve_institution_with_users_for(medresmgr)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(medresmgr_user) == 'admin' then Institution.with_users.to_a.uniq
        when permission_for(medresmgr_user) == 'adminreadonly' then Institution.with_users_seen_by_readonly.to_a.uniq
        when permission_for(medresmgr_user) == 'papmgr' then Institution.with_pap_users.to_a.uniq
        when permission_for(medresmgr_user) == 'medresmgr' then Institution.with_medres_users.to_a.uniq
        end

        expect(profile).to eq(helper.retrieve_institution_with_users_for(medresmgr_user))

      end

    end

    context 'retrieve_label_institutions_with_users_for(user)' do

      it '-retrieve_label_institutions_with_users_for(admin)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(admin) == 'admin' then t('institution_with_users.all')
        when permission_for(admin) == 'adminreadonly' then t('institution_with_users.all')
        when permission_for(admin) == 'papmgr' then t('institution_with_users.pap')
        when permission_for(admin) == 'medresmgr' then t('institution_with_users.medres')

        else

          false
        end

        expect(profile).to eq(helper.retrieve_label_institutions_with_users_for(admin))

      end

      it '-retrieve_label_institutions_with_users_for(adminreadonly)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(adminreadonly) == 'admin' then t('institution_with_users.all')
        when permission_for(adminreadonly) == 'adminreadonly' then t('institution_with_users.all')
        when permission_for(adminreadonly) == 'papmgr' then t('institution_with_users.pap')
        when permission_for(adminreadonly) == 'medresmgr' then t('institution_with_users.medres')

        else

          false
        end

        expect(profile).to eq(helper.retrieve_label_institutions_with_users_for(adminreadonly))

      end

      it '-retrieve_label_institutions_with_users_for(papmgr_user)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(papmgr_user) == 'admin' then t('institution_with_users.all')
        when permission_for(papmgr_user) == 'adminreadonly' then t('institution_with_users.all')
        when permission_for(papmgr_user) == 'papmgr' then t('institution_with_users.pap')
        when permission_for(papmgr_user) == 'medresmgr' then t('institution_with_users.medres')

        else

          false
        end

        expect(profile).to eq(helper.retrieve_label_institutions_with_users_for(papmgr_user))

      end

      it '-retrieve_label_institutions_with_users_for(medresmgr_user)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(medresmgr_user) == 'admin' then t('institution_with_users.all')
        when permission_for(medresmgr_user) == 'adminreadonly' then t('institution_with_users.all')
        when permission_for(medresmgr_user) == 'papmgr' then t('institution_with_users.pap')
        when permission_for(medresmgr_user) == 'medresmgr' then t('institution_with_users.medres')

        else

          false
        end

        expect(profile).to eq(helper.retrieve_label_institutions_with_users_for(medresmgr_user))

      end

      # regular user should be false
      it '-retrieve_label_institutions_with_users_for(user)' do
        profile = case # rubocop:disable Style/EmptyCaseCondition

        when permission_for(user) == 'admin' then t('institution_with_users.all')
        when permission_for(user) == 'adminreadonly' then t('institution_with_users.all')
        when permission_for(user) == 'papmgr' then t('institution_with_users.pap')
        when permission_for(user) == 'medresmgr' then t('institution_with_users.medres')

        else

          false
        end

        expect(profile).to eq(helper.retrieve_label_institutions_with_users_for(user))
        expect(profile).to eq(false)

      end
    end

  end

  #
  # def permitted_options(user, f)
  # profile = case
  #
  # when permission_for(user) == 'admin' then render partial: 'form_admin_profile', locals: { f: f }
  # when permission_for(user) == 'paplocaladm' then render partial: 'form_paplocaladm_profile', locals: { f: f }
  # when permission_for(user) == 'medreslocaladm' then render partial: 'form_medreslocaladm_profile', locals: { f: f }
  # when permission_for(user) == 'medresmgr' then render partial: 'form_medres_manager_profile', locals: { f: f }
  # when permission_for(user) == 'papmgr' then render partial: 'form_pap_manager_profile', locals: { f: f }
  # when permission_for(user) == 'adminreadonly' then #  render partial: "form_profile_readonly", locals: { f: f }
  #
  # end
  # end
  #
