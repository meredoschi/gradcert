class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

# 	after_action :remove_leading_zeros_from_bank_account_number

  def remove_leading_zeros_from_bank_account_number
  	# Since position is significant
  	# Also fixes misinterpretation as being octal integer
		if @numstudents>0 && @student.bankaccount.present?

	    @student.bankaccount.num=@student.bankaccount.num.to_i.to_s

		end

  end

  # GET /students
  def index

    @all_students = Student.all
    @all_contacts=Contact.all

    @search = @all_students.accessible_by(current_ability).ransack(params[:q])
  	@students=@search.result.page(params[:page]).per(10)
		@numstudents=Student.accessible_by(current_ability).count

    @contacts_with_learning_role_not_yet_students=@all_contacts.may_become_students

		@title=t('list')+' '+t('activerecord.models.student').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('people').to_s.pluralize.upcase
      @title+=' | '+t('activerecord.models.student').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('people').to_s.pluralize.upcase
        @title+=' | '+t('activerecord.models.student').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('student').pluralize.upcase

  		end

    end



  end

  # GET /students/1
  def show

    @registrations=Registration.for_student(@student) # For a specific student

    @num_registrations=@registrations.count

  	@title=t('activerecord.models.student').capitalize

  	@num_diplomas=@student.diploma.count

#  	if !@student.name.nil?

#    	@title=@title+": "+@student.name

#     end

  	if is_admin_or_manager(current_user)

			@title=t('people').to_s.pluralize.upcase+" | "+t('activerecord.models.student').capitalize+": "+@student.contact_name

    else

 	 		if is_local_admin(current_user)

				@title=t('people').to_s.upcase+' | '+t('activerecord.models.student').capitalize

			else

				@title=tm('student').pluralize.upcase

				if !@student.name.nil?

					@title+=" : "+@student.name

				end

			end

		end

  end

  # GET /students/new
  def new
    @student = Student.new

    if is_admin_or_manager(current_user)

			@title=t('people').to_s.pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.student')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.student')

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.student')

			end

		end

     @student.build_bankaccount  # singular, one to one

		 # Pluralization in english diploma ends with an a, plural!
		 @student.diploma.build

  end

  # GET /students/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.student')

    if is_admin_or_manager(current_user)

				@title=t('people').to_s.pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.student')

    	else

			if is_local_admin(current_user)

				@title=t('people').to_s.pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.student')

			else

 			  @title=t('noun.edit')+' '+tm('student').pluralize

			end

  	end

  end

  # POST /students
  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to @student, notice: t('activerecord.models.student').capitalize+' '+t('created.m')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /students/1
  def update
    if @student.update(student_params)
     # redirect_to @student, notice: 'Student was successfully updated.'
       redirect_to @student, notice: t('activerecord.models.student').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /students/1
  def destroy

    case
   		when @student.registration.present?
			flash[:alert] = t('student_removal_lock.registration')
			redirect_to students_url
			else

	  	  @student.destroy
  	  	redirect_to students_url, notice: t('activerecord.models.student').capitalize+' '+t('deleted.m')+' '+t('succesfully')

		end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def student_params
      params.require(:student).permit(:contact_id, :profession_id, :previouscode, :previousparticipant, :nationalhealthcareworker, bankaccount_attributes: [:id, :verificationdigit, :num, :digit, :student_id, :bankbranch_id], diploma_attributes: [:id, :councilcredentialstatus, :councilcredentialexpiration, :institution_id, :school_id, :othercourse, :schoolname_id, :council_id, :councilcredential, :coursename_id, :profession_id, :degreetype_id, :externalinstitution, :ongoing, :awarded, :_destroy])
    end
end
