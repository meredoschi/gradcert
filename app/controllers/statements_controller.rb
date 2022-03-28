class StatementsController < ApplicationController
  before_action :set_statement, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

  # GET /statements
  def index
#     @statements = Statement.all

		@title=t('list')+' '+t('activerecord.models.statement').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase
      @title+=' | '+t('activerecord.models.statement').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('navbar.financial').upcase
        @title+=' | '+t('activerecord.models.statement').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('statement').pluralize.upcase

  		end

    end

# //////////////

		# Statements
# 		@all_statements=Statement.includes(registration: [student: :contact]).includes(bankpayment: :payroll).accessible_by(current_ability) # restricted by ability

		@all_statements=Statement.includes(registration: [student: {contact: {user: :institution}}]).includes(bankpayment: :payroll).accessible_by(current_ability) # restricted by ability

		@statements_ordered_by_contact=@all_statements.ordered_by_most_recent_payroll_contact_name

    @search = @statements_ordered_by_contact.ransack(params[:q])

		@statements_without_pagination=@search.result # Used for the PDF report
  	@statements=@search.result.page(params[:page]).per(10)

   	@numstatements=@all_statements.count

		set_index_search_variables

		# http://stackoverflow.com/questions/31910161/how-to-generate-pdf-based-on-search-using-prawn-in-ruby-on-rails

			respond_to do |format|
        format.html
        format.pdf do
			#		export_results_to_pdf
					statements_report
				end
      end


  end

  # GET /statements/1
	def report


	end

  # GET /statements/1
  def show
  	@title=t('activerecord.models.statement').capitalize

 		@registration=@statement.registration

	 	@payroll=@statement.bankpayment.payroll

 		@scholarship_gross_amount=Scholarship.in_effect_for(@payroll).first.amount

 		@absences_discount=@scholarship_gross_amount-@statement.grossamount


#  	if !@statement.name.nil?

#    	@title=@title+": "+@statement.name

#     end

  	if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase+" | "+t('activerecord.models.statement').capitalize+": "+@statement.name

    else

 	 		if is_local_admin(current_user)

				@title=t('navbar_menu_name').to_s.upcase+' | '+t('activerecord.models.statement').capitalize

			else

				@title=tm('statement').pluralize.upcase

				if !@statement.name.nil?

					@title+=" : "+@statement.name

				end

			end

		end

  end

  # GET /statements/new
  def new
    @statement = Statement.new

    if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.statement')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.statement')

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.statement')

			end

		end

  end

  # GET /statements/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.statement')

    if is_admin_or_manager(current_user)

				@title=t('navbar.financial').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.statement')

    	else

			if is_local_admin(current_user)

				@title=t('navbar.financial').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.statement')

			else

 			  @title=t('noun.edit')+' '+tm('statement').pluralize

			end

  	end

  end

  # POST /statements
  def create
    @statement = Statement.new(statement_params)

    if @statement.save
      redirect_to @statement, notice: t('activerecord.models.statement').capitalize+' '+t('created.m')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /statements/1
  def update
    if @statement.update(statement_params)
     # redirect_to @statement, notice: 'Statement was successfully updated.'
       redirect_to @statement, notice: t('activerecord.models.statement').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /statements/1
  def destroy
    @statement.destroy
    redirect_to statements_url, notice: t('activerecord.models.statement').capitalize+' '+t('deleted.m')+' '+t('succesfully')

  end

  private

	def set_index_search_variables

		# Bankpayments

  	@all_bankpayments=Bankpayment.includes(:payroll).ordered_by_most_recent_payroll
		@bankpayment_ids_with_statements=@all_statements.bankpayment_ids # i.e. we payments successfully processed and statements generated
		@bankpayments_with_statements=@all_bankpayments.accessible_by(current_ability).where(id: @bankpayment_ids_with_statements)

		# Registrations
		@all_registrations=Registration.includes(student: :contact)
		@registration_ids_with_statements=@all_statements.registration_ids
		@registrations_with_statements=@all_registrations.accessible_by(current_ability).where(id: @registration_ids_with_statements).ordered_by_contact_name #

		# Institutions

		@all_institutions=Institution.accessible_by(current_ability)
#		@institution_ids_with_statements=@all_statements.institution_ids # Method
# 		@institutions_with_statements=@all_institutions.accessible_by(current_ability).where(id: @institution_ids_with_statements)


	end


	def set_payment_amount

		if @statement.bankpayment.payroll.special?

			 payment=@statement.bankpayment.payroll.amount

		else

	    payment=Scholarship.in_effect_for(@statement.bankpayment.payroll).first.amount

  	end

		return payment

	end



    # Use callbacks to share common setup or constraints between actions.
    def set_statement
      @statement = Statement.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def statement_params
      params.require(:statement).permit(:registration_id, :bankpayment_id, :grossamount, :incometax, :socialsecurity, :childsupport, :netamount)
    end
end
