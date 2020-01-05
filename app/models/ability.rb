# Provides fine grained control given roles and permissions
class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    # 	http://stackoverflow.com/questions/18624489/rails-how-can-i-tell-if-a-record-has-a-child-record-in-any-one-of-its-child-tab

    alias_action :create, :read, :update, :destroy, to: :crud

    alias_action :create, :update, :destroy, to: :cud

    def superuser(_user)
      can :manage, :all
      # Block changing or destroying current permissions
      # New permissions may be added in the future (if need be)
      cannot %i[destroy update], Permission,
             kind: %w[admin adminreadonly pap medres papcollaborator
                      medrescollaborator paplocaladm medreslocaladm papmgr medresmgr]
    end

    def read_only(user)
      can :read, :all
      can %i[read update], User, id: user.id
      can %i[read update], Contact, user: { id: user.id }
      # ----	exceptions ---------
      # 			cannot :read, User, {:admin=>true}

      cannot :read, User, permission: { kind: 'admin' }

      # --------------------------
    end

    def medical_residency_manager(_user)
      can :crud, :all

      cannot %i[create update destroy],
             [State, Country, Stateregion, Streetname, Municipality, Institutiontype,
              Permission, Role, Regionaloffice, Methodology, Profession, Degreetype]

      cannot :read, Role, medres: false

      # ----	exceptions ---------
      # cannot :manage, User, {:pap=>true}
      # cannot :manage, User, {:paplocaladm=>true}
      # cannot :manage, User, {:papmgr=>true}
      # cannot :manage, User, {:adminreadonly=>true}
      # cannot :manage, User, {:admin=>true}

      cannot :crud, User, permission: { kind: 'papcollaborator' }
      cannot :crud, User, permission: { kind: 'pap' }
      cannot :crud, User, permission: { kind: 'paplocaladm' }
      cannot :crud, User, permission: { kind: 'papmgr' }
      cannot :crud, User, permission: { kind: 'adminreadonly' }
      cannot :crud, User, permission: { kind: 'admin' }

      #       	cannot :manage, Contact, user: {:pap=>true}
      # 				cannot :manage, Contact, user: {:paplocaladm=>true}
      # 				cannot :manage, Contact, user: {:papmgr=>true}
      # 				cannot :manage, Contact, user: {:adminreadonly=>true}
      # 				cannot :manage, Contact, user: {:admin=>true}

      cannot :crud, Contact, user: { permission: { kind: 'papcollaborator' } }
      cannot :crud, Contact, user: { permission: { kind: 'pap' } }
      cannot :crud, Contact, user: { permission: { kind: 'paplocaladm' } }
      cannot :crud, Contact, user: { permission: { kind: 'papmgr' } }
      cannot :crud, Contact, user: { permission: { kind: 'adminreadonly' } }
      cannot :crud, Contact, user: { permission: { kind: 'admin' } }

#      cannot [:destroy], Institution, pap: true, provisional: false
      cannot [:destroy], Institution, provisional: false

      cannot %i[update destroy], Program, pap: true
      cannot %i[update destroy], Programname, pap: true

      cannot %i[create destroy], Role
      cannot [:update], Role, pap: true

      cannot [:destroy], Programname.with_children

      # --------------------------
      cannot %i[update destroy], Programname, pap: true

      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'pap' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'papmgr' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'papcollaborator' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'paplocaladm' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'admin' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'adminreadonly' } } }

      cannot :crud, Assignment, supervisor: { contact: { user: { permission: { kind: 'pap' } } } }
      cannot :crud, Assignment,
             supervisor: { contact: { user: { permission: { kind: 'papcollaborator' } } } }
      cannot :crud, Assignment,
             supervisor: { contact: { user: { permission: { kind: 'paplocaladm' } } } }
      cannot :crud, Assignment,
             supervisor: { contact: { user: { permission: { kind: 'admin' } } } }
      cannot :crud, Assignment,
             supervisor: { contact: { user: { permission: { kind: 'adminreadonly' } } } }

      cannot :cud, Healthcareinfo
      cannot :cud, College
      cannot :cud, Researchcenter
      cannot :cud, Characteristic
    end

    def pap_manager(_user)
      can :crud, :all

      # 2018
      can [:bankletter], [Contact]

      #
      #         can :generatefile, Bankpayment
      #
      #         can :report, Bankpayment
      #
      #         can :report2, Bankpayment
      #
      #         can :report, Payroll
      #
      #         can :calculate, Payroll
      #
      #         can :clear, Payroll
      #

      # 2017 registration #
      can %i[legalform receipt declaration], Registration

      can %i[read update], Makeupschedule

      #    cannot %i[update destroy], [Payroll, Bankpayment], done: true

      cannot %i[clear calculate update], Payroll.completed # Hotfix

      cannot %i[destroy], Payroll

      cannot %i[update destroy], [Bankpayment], done: true

      # To fix!
      # https://stackoverflow.com/questions/41277395/cancanerror-the-can-and-cannot-call-cannot-be-used-with-a-raw-sql-can-de
      #      cannot %i[update destroy], Annotation, id: Payroll.completed

      can %i[generatefile report report2 insurancereport insurancecsv
             totalreport statements statementspdf sefip producestatements], Bankpayment

      can %i[report calculate clear absences], Payroll

      # 				can :read, Institution, welcome

      cannot :cud, [State, Country, Stateregion, Streetname, Municipality,
                    Institutiontype, Permission, Role, Regionaloffice,
                    Methodology, Profession, Degreetype, Schoolterm, Leavetype]

      # ----	exceptions ---------

      cannot :read, Role, pap: false

      cannot :read, Course

      cannot [:destroy], [Professionalspecialty, Professionalarea, Bankbranch,
                          Professionalfamily, Registration, Student]

      can :destroy, Registration,
          schoolyear: { program: { schoolterm: { id: Schoolterm.latest.id } } }

      can :destroy, Student.incoming

      cannot :crud, User, permission: { kind: 'medrescollaborator' }
      cannot :crud, User, permission: { kind: 'medres' }
      cannot :crud, User, permission: { kind: 'medreslocaladm' }
      cannot :crud, User, permission: { kind: 'medresmgr' }
      cannot :crud, User, permission: { kind: 'adminreadonly' }
      cannot :crud, User, permission: { kind: 'admin' }

      cannot :crud, Contact, user: { permission: { kind: 'medrescollaborator' } }
      cannot :crud, Contact, user: { permission: { kind: 'medres' } }
      cannot :crud, Contact, user: { permission: { kind: 'medreslocaladm' } }
      cannot :crud, Contact, user: { permission: { kind: 'medresmgr' } }
      cannot :crud, Contact, user: { permission: { kind: 'adminreadonly' } }
      cannot :crud, Contact, user: { permission: { kind: 'admin' } }

#     cannot [:destroy], Institution, medres: true, provisional: false
      cannot [:destroy], Institution, provisional: false

      cannot %i[update destroy], Program, medres: true
      cannot %i[update destroy], Programname, medres: true
      cannot [:destroy], Programname.with_children

      cannot %i[create destroy], Role
      cannot [:update], Role, medres: true

      cannot %i[update destroy], Bankpayment, done: true

      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'medres' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'medresmgr' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'medrescollaborator' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'medreslocaladm' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'admin' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'adminreadonly' } } }

      cannot :crud, Assignment,
             supervisor: { contact: { user: { permission: { kind: 'medres' } } } }
      cannot :crud, Assignment,
             supervisor: { contact: { user: { permission: { kind: 'medrescollaborator' } } } }
      cannot :crud, Assignment,
             supervisor: { contact: { user: { permission: { kind: 'medreslocaladm' } } } }
      cannot :crud, Assignment,
             supervisor: { contact: { user: { permission: { kind: 'admin' } } } }
      cannot :crud, Assignment,
             supervisor: { contact: { user: { permission: { kind: 'adminreadonly' } } } }

      # 		     cannot [:update, :destroy], Healthcareinfo, { institution: {:medres => true} }

      # --------------------------

      # Training
      cannot [:destroy], Contact.confirmed
    end

    def local_pap_administrator(user)
      #   		can [:legalform, :receipt, :declaration], Registration
      #  Currently not allowed to update own program details
      # 	can [:update], Program, {:institution_id => user.institution_id, :pap=>true}

      # Uncomment to allow, if needed .
      # To do: fully test

      can %i[read], Programname

      # Institution details

      #             can :crud, Healthcareinfo, {:institution_id => user.institution_id}
      #             can :crud, Researchcenter, {:institution_id => user.institution_id}
      #             can :crud, Characteristic, {:institution_id => user.institution_id}
      #             can :crud, College, {:institution_id => user.institution_id}
      #
      # Supervisors
      #
      # ---- Able to "manage" supervisors from own institution
      #
      #   can :crud, Supervisor, contact: { user: { :institution_id => user.institution_id } }
      #
      #       can :crud, Supervisor
      #
      # ----- Supervisor
      #
      # 	   can [:read, :update, :destroy],
      #          Supervisor, contact: { user: {:institution_id=> user.institution_id } }
      #
      #       can [:create], Supervisor #
      #
      # -----
      #
      #              can :crud, Assignment
      #

      can %i[legalform receipt declaration export], Registration

      can [:bankletter], [Contact]

      can %i[read report], [Payroll]

      can %i[read institutionstatementspdf], Bankpayment, resend: false

      can [:read], Statement,
          registration: { student: { contact: { user: { institution_id: user.institution_id } } } }

      can [:read], [School, Coursename]

      # Future
      #  	can [:report, :absences],  Payroll

      can [:read], Program, institution_id: user.institution_id

      # ---- Able to "manage" own programs

      # can :crud, Program, {:institution_id => user.institution_id, :pap=>true}

      # ---- Able to read and update own institution details

      can %i[read update], Institution, id: user.institution_id

      can :annotationsreport, Payroll

      # ---- Able to "manage" users from own institution

      can :crud, User, institution_id: user.institution_id

      # with the exception of

      cannot :crud, User, permission: { kind: 'medrescollaborator' }
      cannot :crud, User, permission: { kind: 'medres' }
      cannot :crud, User, permission: { kind: 'medreslocaladm' }
      cannot :crud, User, permission: { kind: 'medresmgr' }
      cannot :crud, User, permission: { kind: 'papmgr' }
      cannot :crud, User, permission: { kind: 'adminreadonly' }
      cannot :crud, User, permission: { kind: 'admin' }

      can [:read], Program, institution_id: user.institution_id, pap: true

      # ---- Able to "manage" contacts from own institution
      can :crud, Contact, user: { institution_id: user.institution_id }

      # with the exception of

      cannot :crud, Contact, user: { permission: { kind: 'admin' } }
      cannot :crud, Contact, user: { permission: { kind: 'adminreadonly' } }
      cannot :crud, Contact, user: { permission: { kind: 'papmgr' } }
      cannot :crud, Contact, user: { permission: { kind: 'medresmgr' } }
      cannot :crud, Contact, user: { permission: { kind: 'medreslocaladm' } }
      cannot :crud, Contact, user: { permission: { kind: 'medres' } }
      cannot :crud, Contact, user: { permission: { kind: 'medrescollaborator' } }
      can [:read], Event,
          registration: { student: { contact: { user: { institution_id: user.institution_id } } } }

      # Local admins enter their monthly data (pending confirmation by Pap Managers)

      if data_entry_permitted_on_latest_payroll?

        can [:create], Event

        can %i[update destroy], Event, confirmed: false, processed: false,
                                       registration: { student: { contact:
                                         { user: { institution_id: user.institution_id } } } }

        can [:update], Registration.contextual_today,
            student: { contact: { user: { institution_id: user.institution_id } } }

        can [:update], Student,
            contact: { user: { institution_id: user.institution_id } }

        # 	can [:create], Registration # restricted to current institution by the application logic

      end

      #
      #        can [:read], Event,  registration:
      #         {student: { contact: { user: {:institution_id=> user.institution_id } } } }
      #
      #          can [:read],  Registration,
      #          student: { contact: { user: {:institution_id=> user.institution_id } } }
      #
      #         can [:read], Student,
      #         contact: { user: {:institution_id=> user.institution_id } }
      #
      #         cannot [:create, :update, :delete], Contact
      #
      #      end
      #

      # ********************************************************************
      #

      # --- Annotations

      can [:read], Annotation,
          registration: { student: { contact: { user: { institution_id: user.institution_id } } } }

      #    	 	can [:create], Annotation
      # when enabled should be restricted to current institution by the application logic

      #       can :crud, Supervisor, contact: { user: {:institution_id=> user.institution_id } }

      # Assignments

      # 	 	 	can [:read, :update, :destroy], Assignment,
      #     supervisor: { contact: { user: { :institution_id => user.institution_id } } }

      #    	 	can [:create], Assignment # restricted to current institution by the application logic

      # 		  can :crud, Assignment,
      # supervisor: { contact: { user: { :institution_id => user.institution_id } } }

      # with the exception of

      #	cannot :crud, Supervisor, contact: { user: {permission: {:kind=>'admin'} } }
      #	cannot :crud, Supervisor, contact: { user: {permission: {:kind=>'adminreadonly'} } }
      #	cannot :crud, Supervisor, contact: { user: {permission: {:kind=>'papmgr'} } }
      #	cannot :crud, Supervisor, contact: { user: {permission: {:kind=>'medresmgr'} } }
      #	cannot :crud, Supervisor, contact: { user: {permission: {:kind=>'medreslocaladm'} } }
      #	cannot :crud, Supervisor, contact: { user: {permission: {:kind=>'medrescollaborator'} } }
      #	cannot :crud, Supervisor, contact: { user: {permission: {:kind=>'medres'} } }

      # -------

      # ---- Able to assign supervisors from own institution to programs

      # with the exception of

      # 	  can :crud, Assignment

      #  supervisor: { contact: { user: {:institution_id=>user.institution_id}}}

      #	cannot :crud, Assignment, supervisor: { contact: { user: {permission: {:kind=>'admin'} } } }
      #	cannot :crud, Assignment,
      #   supervisor: { contact: { user: {permission: {:kind=>'adminreadonly'} } } }
      #	cannot :crud, Assignment,
      # supervisor: { contact: { user: {permission: {:kind=>'papmgr'} } } }
      #	cannot :crud, Assignment,
      # supervisor: { contact: { user: {permission: {:kind=>'medresmgr'} } } }
      #	cannot :crud, Assignment,
      # supervisor: { contact: { user: {permission: {:kind=>'medreslocaladm'} } } }
      #	cannot :crud, Assignment,
      # supervisor: { contact: { user: {permission: {:kind=>'medrescollaborator'} } } }
      #	cannot :crud, Assignment,
      # supervisor: { contact: { user: {permission: {:kind=>'medres'} } } }
      # ----
      # 			can :crud, Assignment,  supervisor: {contact: { user:
      # { :institution_id => user.institution_id, :admin => false, :adminreadonly => false,
      # :medres=>false, :medreslocaladm=>false, :medresmgr=>false } } }

      # ---- Sees healthcareinfo from own institution

      #  	  can [:create, :read, :update], Healthcareinfo, institution: {id: user.institution_id}

      # 	    cannot [:update], [Registration]

      # ---- Schoolyears
      can [:read], Schoolyear, program: { institution: { id: user.institution_id } }

      # ----

      cannot [:destroy], [User, Contact, Student, Registration]

      # 			cannot [:create], [User, Contact, Student, Registration] # After initial training

      # Statements - Future
      #   can [:read], Statement, registration: {student: { contact:
      # { user: { :institution_id => user.institution_id } } } }

      cannot %i[update destroy],  Event, residual: true

      cannot %i[update destroy],  Event, processed: true

      # Training - Registration season

      #	    can [:destroy],  Contact.childless, contact:
      #     { user: {:institution_id=> user.institution_id } }

      #   can [:destroy],  Contact, contact: { user: {:institution_id=> user.institution_id } }

      can [:destroy],  Contact.not_confirmed.childless

      can [:destroy],  Student.not_registered, contact:
      { user: { institution_id: user.institution_id } }

      # 	  can [:destroy],  Registration, student: { contact: { user:
      #  {:institution_id=> user.institution_id } } }, school_term: Schoolterm.latest

      can [:update], Contact: { user: { institution_id: user.institution_id } }

      #      places_available=Placesavailable.where(institution_id: user.institution_id,
      #      schoolterm_id: Schoolterm.latest, allowregistrations: true).exists?
      #
      #       if Placesavailable,

      cannot [:create], [User, Contact, Student, Registration]

      can [:read], Event, registration: { student: { contact:
        { user: { institution_id: user.institution_id } } } }

      #   if open_season? && places_available?(user)

      can [:read], Registration, student: { contact: { user:
        { institution_id: user.institution_id } } }
      can [:read], Student, contact: { user: { institution_id: user.institution_id } }

      if registrations_permitted? && places_available?(user)

        can [:create], [User, Contact, Student, Registration]
        can [:update],  Student, contact: { user: { institution_id: user.institution_id } }

        can [:update],  Registration, student: { contact: { user:
          { institution_id: user.institution_id } } }, school_term: Schoolterm.latest

        # 	      cannot [:update],  Contact.not_incoming
        #  Made this more general

      end

      cannot [:update],  Contact.not_incoming

      #   cannot [:update],  Contact.paplocalhr

      cannot [:update],  Student.not_incoming
      # Sensible default - alterations to bank information for veterans is not allowed
      # Managers will perform it (exceptional cases) if there is a change
      # such as change in Bankbranch number (mostly due to closures)

      can [:update],  Contact.veterans_today

      can [:update],  Student.veterans_today

      can [:update],  Student.repeat_registration

      can [:update],  Contact.repeat_registration

      can [:update],  Student.makeup_registration

      can [:update],  Contact.makeup_registration

      # New for 2017
      can [:read], Placesavailable, institution_id: user.institution_id

      can [:read], [Schoolterm, Bankbranch, Profession, School]
      # -----

      can %i[read update], Admission, program: { institution_id: user.institution_id }

      cannot %i[read update], Admission, program:
      { schoolterm_id: Schoolterm.admissions_data_entry_not_in_range }

      #      can [:update],  Admission.within_data_entry_period,
      #        {program: {:institution_id => user.institution_id} }

      #  can [:update],  Program, {:institution_id => user.institution_id}
    end

    def local_medical_residency_administrator(user)
      # http://stackoverflow.com/questions/12885246/authorising-child-objects-through-a-parents-association-using-cancan

      can %i[read update], Institution, id: user.institution_id

      # ---- Able to "manage" users from own institution

      can :crud, User, institution_id: user.institution_id

      # with the exception of

      cannot :crud, User, permission: { kind: 'papcollaborator' }
      cannot :crud, User, permission: { kind: 'pap' }
      cannot :crud, User, permission: { kind: 'paplocaladm' }
      cannot :crud, User, permission: { kind: 'papmgr' }
      cannot :crud, User, permission: { kind: 'medresmgr' }
      cannot :crud, User, permission: { kind: 'adminreadonly' }
      cannot :crud, User, permission: { kind: 'admin' }

      can [:read], Program, institution_id: user.institution_id, medres: true

      can [:update], Program, institution_id: user.institution_id, medres: true

      # ---- Able to "manage" contacts from own institution
      can :crud, Contact, user: { institution_id: user.institution_id }

      # with the exception of

      cannot :crud, Contact, user: { permission: { kind: 'admin' } }
      cannot :crud, Contact, user: { permission: { kind: 'adminreadonly' } }
      cannot :crud, Contact, user: { permission: { kind: 'medresmgr' } }
      cannot :crud, Contact, user: { permission: { kind: 'papmgr' } }
      cannot :crud, Contact, user: { permission: { kind: 'paplocaladm' } }
      cannot :crud, Contact, user: { permission: { kind: 'pap' } }
      cannot :crud, Contact, user: { permission: { kind: 'papcollaborator' } }
      # -----------

      # ---- Able to "manage" supervisors from own institution

      # with the exception of

      #			can :crud, Supervisor, contact: { user: { :institution_id => user.institution_id } }

      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'admin' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'adminreadonly' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'papmgr' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'medresmgr' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'paplocaladm' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'papcollaborator' } } }
      cannot :crud, Supervisor, contact: { user: { permission: { kind: 'pap' } } }

      # -------

      # 			can :crud, Assignment, supervisor: {contact: { user:
      #       { :institution_id => user.institution_id, :admin => false, :adminreadonly => false,
      #       :medres=>false, :medreslocaladm=>false, :medresmgr=>false } } }

      # ---- Able to assign supervisors from own institution to programs

      # with the exception of

      # 			can :crud, Assignment, supervisor: {contact: { user:
      #       { :institution_id => user.institution_id } } }

      # 			can :crud, Assignment, supervisor: { contact: { user: {institution: {:id=>'38'} } } }

      #		cannot :crud, Assignment,
      #   supervisor: { contact: { user: {permission: {:kind=>'admin'} } } }
      #		cannot :crud, Assignment,
      #   supervisor: { contact: { user: {permission: {:kind=>'adminreadonly'} } } }
      #		cannot :crud, Assignment,
      #     supervisor: { contact: { user: {permission: {:kind=>'papmgr'} } } }
      #		cannot :crud, Assignment,
      #     supervisor: { contact: { user: {permission: {:kind=>'medresmgr'} } } }
      #		cannot :crud, Assignment,
      #    supervisor: { contact: { user: {permission: {:kind=>'paplocaladm'} } } }
      #		cannot :crud, Assignment,
      #     supervisor: { contact: { user: {permission: {:kind=>'papcollaborator'} } } }
      # 		cannot :crud, Assignment,
      #       supervisor: { contact: { user: {permission: {:kind=>'pap'} } } }
    end

    def regular_user(user)
      can :read, Institution, id: user.institution_id
      can %i[read update], User, id: user.id
      can %i[read update], Contact, user: { id: user.id }

      if Supervisor.registered?(user)

        can %i[read update], Supervisor, contact: { user: { id: user.id } }

      end

      return unless Assignment.exists_for_supervisor?(user)
      can [:read], Assignment, supervisor: { contact: { user_id: user.id } }
    end

    def pap(user)
      # 			can :read, Institution, {:id => user.institution_id}
      # 			can [:read, :update], User, {:id => user.id}
      # 		 	can [:read, :update], Contact, user: { :id => user.id }

      regular_user(user)
    end

    def medical_residency(user)
      regular_user(user)
    end

    def collaborator(user)
      can [:read], Assessment, contact: { user_id: user.id }

      can %i[read update], Programsituation, assessment: { contact: { user_id: user.id } }

      #   	can :crud, Programsituation

      # 		  can :crud, Assessment, contact: { :user_id => user.id }

      # 		  can :crud, Assessment

      regular_user(user)
    end

    def pap_collaborator(user)
      collaborator(user)
    end

    def medical_residency_collaborator(user)
      collaborator(user)
    end

    # 		superuser(user)

    #       if user.permission_type=='medresmgr'then	medical_residency_manager(user)

    # 			else pap(user)

    #   		end

    # 		medical_residency_manager(user)
    userpermissions = if user.permission_type == 'admin' then superuser(user)
                      elsif user.permission_type == 'adminreadonly' then read_only(user)

                      # Pap
                      elsif user.permission_type == 'papmgr' then pap_manager(user)
                      elsif user.permission_type == 'paplocaladm' then local_pap_administrator(user)
                      elsif user.permission_type == 'pap' then pap(user)
                      elsif user.permission_type == 'papcollaborator' then pap_collaborator(user)

                      # Medical Residency
                      elsif user.permission_type == 'medresmgr'
                        medical_residency_manager(user)
                      elsif user.permission_type == 'medreslocaladm'
                        local_medical_residency_administrator(user)
                      elsif user.permission_type == 'medres'
                        medical_residency(user)
                      elsif user.permission_type == 'medrescollaborator'
                        medical_residency_collaborator(user)
                      else 'undefined'
                      end
  end

  def places_available?(user)
    Placesavailable.where(institution_id: user.institution_id,
                          schoolterm_id: Schoolterm.latest, allowregistrations: true).exists?
  end

  private

  # N.B. Used two methods here explicitly.  Could have tested for permission_type...

  # Pap payroll cycle - When it is possible for local admins to inform their
  # monthly events, changes in registration situation, etc
  def start_of_pap_payroll_cycle?
    (Date.today.day >= Settings.payroll_cycle_opening_day_for_local_admins.pap) ||
      (Date.today.day < Settings.payroll_cycle_closing_day_for_local_admins.pap)
  end

  # Medical residency payroll cycle
  def start_of_medres_payroll_cycle?
    (Date.today.day >= Settings.payroll_cycle_opening_day_for_local_admins.medres) ||
      (Date.today.day < Settings.payroll_cycle_closing_day_for_local_admins.medres)
  end

  def open_season?
    Schoolterm.open_season?
  end

  # New for May 2017
  def data_entry_permitted_on_latest_payroll?

    if Payroll.actual.count.positive?
          latest_payroll = Payroll.actual.latest.first
          latest_payroll.dataentrypermitted?
    else
       return false
    end
  end


  # New for May 2017
  # Hotfix 27/4/17
  # See: schoolterm_spec.rb (in_season? was already defined on registrations helper)
  def registrations_permitted?
#    start = Settings.registration_season.start
#    finish = Settings.registration_season.finish

    start = Schoolterm.latest.seasondebut # dynamically set

    finish = Schoolterm.latest.seasonclosure


    Logic.within?(start, finish, Time.now)
  end
end
