# Attempt to handle the various permissions gracefully
# Refer to ability.rb (CanCan)
class Permission < ActiveRecord::Base
  has_many :user, foreign_key: 'permission_id'

  def self.readonly
    where("permissions.kind<>'admin'")
  end

  # Alternate syntax
  def self.paplocalhr
    where("permissions.kind='paplocaladm'")
  end

  # Permissions granted to pap local administrators - excludes external experts "papcollaborators"
  def self.paplocal
    if Schoolterm.open_season?

      where("permissions.kind='pap'")

    else

      where("permissions.kind='paplocaladm'")

    end
  end

  # Refer to: users_helper.rb, retrieve_users_permissions_for(user)
  def self.regular
    where(kind: %i[pap medres])
  end

  # Refined for registration season
  def regular?
    kind == 'pap' || kind == 'medres'
  end

  def staff?
    !regular?
  end

  # PAP
  def self.pap
    where(kind: %i[pap papcollaborator paplocaladm papmgr])
  end

  # Medical Residency
  def self.medres
    where(kind: %i[medres medrescollaborator medreslocaladm medresmgr])
  end

  def self.paplocalrealm
    where(kind: %i[pap paplocaladm])
    #		where(kind: %i[pap papcollaborator paplocaladm]) # For the future
  end

  def self.medreslocalrealm
    where(kind: %i[medres medreslocaladm])
    #		where(kind: %i[medres medrescollaborator medreslocaladm]) # For the future
  end

  # Student or Collaborator
  def self.regular_or_collaborator
    where(kind: %i[pap medres papcollaborator medrescollaborator])
  end

  # System administrators - Implemented as one responsible for all teaching areas
  def self.admin
    where(kind: :admin)
  end

  # Managers - oversee institutions in their sector (teaching area).  Examples: Pap, Medres
  def self.manager
    where(kind: %i[papmgr medresmgr])
  end

  # Local administrators
  def self.localadmin
    where(kind: %i[paplocaladm medreslocaladm])
  end

  # Permission belongs to Pap
  def pap?
    Permission.pap.pluck(:kind).include? kind
  end

  # Permission belongs to Medres
  def medres?
    Permission.medres.pluck(:kind).include? kind
  end

  # Is local administrator?
  def localadmin?
    Permission.localadmin.pluck(:kind).include? kind
  end

  # Is manager
  def manager?
    Permission.manager.pluck(:kind).include? kind
  end

  # Is system administrator?
  def admin?
    Permission.admin.pluck(:kind).include? kind
  end

  def self.own_institution(user)
    joins(user: :institution).where('institutions.id = ?  ', user.institution_id).uniq
  end

  def self.default_scope
    order('description ASC')
  end
end
