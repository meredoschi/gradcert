class SchooltermsController < ApplicationController
  before_action :set_schoolterm, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

  # GET /schoolterms
  def index
    @schoolterms = Schoolterm.all

		@title=t('list')+' '+t('activerecord.models.schoolterm').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('definition').pluralize.to_s.upcase
      @title+=' | '+t('activerecord.models.schoolterm').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('definition').pluralize.to_s.upcase
        @title+=' | '+t('activerecord.models.schoolterm').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('schoolterm').pluralize.upcase

  		end

    end


  	@search = Schoolterm.accessible_by(current_ability).ransack(params[:q])
  	@schoolterms=@search.result.page(params[:page]).per(10)
		@numschoolterms=Schoolterm.count

  end

  # GET /schoolterms/1
  def show
  	@title=t('activerecord.models.schoolterm').capitalize

#  	if !@schoolterm.name.nil?

#    	@title=@title+": "+@schoolterm.name

#     end

  	if is_admin_or_manager(current_user)

			@title=t('definition').pluralize.to_s.upcase+" | "+t('activerecord.models.schoolterm').capitalize+": "+@schoolterm.name

    else

 	 		if is_local_admin(current_user)

				@title=t('navbar_menu_name').to_s.upcase+' | '+t('activerecord.models.schoolterm').capitalize

			else

				@title=tm('schoolterm').pluralize.upcase

				if !@schoolterm.name.nil?

					@title+=" : "+@schoolterm.name

				end

			end

		end

  end

  # GET /schoolterms/new
  def new
    @schoolterm = Schoolterm.new

    if is_admin_or_manager(current_user)

			@title=t('definition').pluralize.to_s.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.schoolterm')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.schoolterm')

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.schoolterm')

			end

		end

  end

  # GET /schoolterms/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.schoolterm')

    if is_admin_or_manager(current_user)

				@title=t('definition').pluralize.to_s.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.schoolterm')

    	else

			if is_local_admin(current_user)

				@title=t('definition').pluralize.to_s.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.schoolterm')

			else

 			  @title=t('noun.edit')+' '+tm('schoolterm').pluralize

			end

  	end

  end

  # POST /schoolterms
  def create
    @schoolterm = Schoolterm.new(schoolterm_params)

    if @schoolterm.save
      redirect_to @schoolterm, notice: t('activerecord.models.schoolterm').capitalize+' '+t('created.m')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /schoolterms/1
  def update
    if @schoolterm.update(schoolterm_params)
     # redirect_to @schoolterm, notice: 'Schoolterm was successfully updated.'
       redirect_to @schoolterm, notice: t('activerecord.models.schoolterm').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /schoolterms/1
  def destroy
    @schoolterm.destroy
    redirect_to schoolterms_url, notice: t('activerecord.models.schoolterm').capitalize+' '+t('deleted.m')+' '+t('succesfully')

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schoolterm
      @schoolterm = Schoolterm.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def schoolterm_params
      params.require(:schoolterm).permit(:start, :finish, :duration, :seasondebut, :seasonclosure, :pap, :medres, :registrationseason, :scholarshipsoffered, :admissionsdebut, :admissionsclosure)
    end
end
