class BankbranchesController < ApplicationController
  before_action :set_bankbranch, only: [:show, :edit, :update, :destroy]

#	before_action :authenticate_user! # By default... Devise

#	load_and_authorize_resource  # CanCan(Can)

  # GET /bankbranches
  def index
    @bankbranches = Bankbranch.all

		@title=t('list')+' '+t('activerecord.models.bankbranch').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.bankbranch').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.bankbranch').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('bankbranch').pluralize.upcase

  		end

    end


  	@search = Bankbranch.accessible_by(current_ability).ransack(params[:q])
  	@bankbranches=@search.result.page(params[:page]).per(10)
		@numbankbranches=Bankbranch.count

  end

  # GET /bankbranches/1
  def show
  	@title=t('activerecord.models.bankbranch').capitalize

#  	if !@bankbranch.name.nil?

#    	@title=@title+": "+@bankbranch.name

#     end

  	if is_admin_or_manager(current_user)

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.bankbranch').capitalize+": "+@bankbranch.name

    else

 	 		if is_local_admin(current_user)

				@title=t('navbar_menu_name').mb_chars.upcase+' | '+t('activerecord.models.bankbranch').capitalize

			else

				@title=tm('bankbranch').pluralize.upcase

				if !@bankbranch.name.nil?

					@title+=" : "+@bankbranch.name

				end

			end

		end

  end

  # GET /bankbranches/new
  def new
    @bankbranch = Bankbranch.new

 	  @bankbranch.build_address

    @bankbranch.build_phone

    if is_admin_or_manager(current_user)

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.f')+" "+t('activerecord.models.bankbranch')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.bankbranch')

			else

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.bankbranch')

			end

		end

  end

  # GET /bankbranches/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.bankbranch')

    if is_admin_or_manager(current_user)

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.bankbranch')

    	else

			if is_local_admin(current_user)

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.bankbranch')

			else

 			  @title=t('noun.edit')+' '+tm('bankbranch').pluralize

			end

  	end

  end

  # POST /bankbranches
  def create
    @bankbranch = Bankbranch.new(bankbranch_params)

    set_numerical_code

    if @bankbranch.save
      redirect_to @bankbranch, notice: t('activerecord.models.bankbranch').capitalize+' '+t('created.m')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /bankbranches/1
  def update

    set_numerical_code

    if @bankbranch.update(bankbranch_params)
     # redirect_to @bankbranch, notice: 'Bankbranch was successfully updated.'
       redirect_to @bankbranch, notice: t('activerecord.models.bankbranch').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /bankbranches/1
  def destroy
    @bankbranch.destroy
    redirect_to bankbranches_url, notice: t('activerecord.models.bankbranch').capitalize+' '+t('deleted.m')+' '+t('succesfully')

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bankbranch
      @bankbranch = Bankbranch.find(params[:id])
    end

    def set_numerical_code

      @bankbranch.numericalcode=@bankbranch.code.to_i 

    end
    # Only allow a trusted parameter "white list" through.
    def bankbranch_params
      params.require(:bankbranch).permit(:id, :code, :name, :formername, :verificationdigit, :opened, :address_id, :phone_id, address_attributes: [:id, :municipality_id, :streetname_id, :country_id, :internal, :postalcode, :addr, :complement, :neighborhood, :streetnum, :institution_id, :contact_id], phone_attributes: [:id, :main, :other, :mobile, :bankbranch_id])

    end
end
