class ScholarshipsController < ApplicationController
  before_action :set_scholarship, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

  # GET /scholarships
  def index
    @scholarships = Scholarship.all

		@title=t('list')+' '+t('activerecord.models.scholarship').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase
      @title+=' | '+t('activerecord.models.scholarship').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('navbar.financial').upcase
        @title+=' | '+t('activerecord.models.scholarship').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('scholarship').pluralize.upcase

  		end

    end


  	@search = Scholarship.accessible_by(current_ability).ransack(params[:q])
  	@scholarships=@search.result.page(params[:page]).per(10)
		@numscholarships=Scholarship.count

  end

  # GET /scholarships/1
  def show
  	@title=t('activerecord.models.scholarship').capitalize

#  	if !@scholarship.name.nil?

#    	@title=@title+": "+@scholarship.name

#     end

  	if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase+" | "+t('activerecord.models.scholarship').capitalize+": "+@scholarship.name

    else

 	 		if is_local_admin(current_user)

				@title=t('definition').mb_chars.upcase+' | '+t('activerecord.models.scholarship').capitalize

			else

				@title=tm('scholarship').pluralize.upcase

				if !@scholarship.name.nil?

					@title+=" : "+@scholarship.name

				end

			end

		end

  end

  # GET /scholarships/new
  def new
    @scholarship = Scholarship.new

    if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.scholarship')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.scholarship')

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.scholarship')

			end

		end

    set_sector

  end

  # GET /scholarships/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.scholarship')

    if is_admin_or_manager(current_user)

				@title=t('navbar.financial').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.scholarship')

    	else

			if is_local_admin(current_user)

				@title=t('navbar.financial').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.scholarship')

			else

 			  @title=t('noun.edit')+' '+tm('scholarship').pluralize

			end

  	end

  end

  # POST /scholarships
  def create
    @scholarship = Scholarship.new(scholarship_params)

		set_number_of_days
		set_sector

    if @scholarship.save
      redirect_to @scholarship, notice: t('activerecord.models.scholarship').capitalize+' '+t('created.m')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /scholarships/1
  def update

		set_number_of_days
		set_sector

    if @scholarship.update(scholarship_params)
     # redirect_to @scholarship, notice: 'Scholarship was successfully updated.'
       redirect_to @scholarship, notice: t('activerecord.models.scholarship').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /scholarships/1
  def destroy
    @scholarship.destroy
    redirect_to scholarships_url, notice: t('activerecord.models.scholarship').capitalize+' '+t('deleted.m')+' '+t('succesfully')

  end

  private

    		# Applies to managers only
    def set_sector

			if is_pap_manager(current_user)

				@scholarship.pap=true

			end

			if is_medres_manager(current_user)

				@scholarship.medres=true

			end

    end

    	# Set days since application's Epoch

    def set_number_of_days

			@scholarship.daystarted=@scholarship.startday
			@scholarship.dayfinished=@scholarship.finishday

		end

    # Use callbacks to share common setup or constraints between actions.
    def set_scholarship
      @scholarship = Scholarship.find(params[:id])
    end

		# Applies to managers only
    def set_sector

			if is_pap_manager(current_user)

				@scholarship.pap=true

			end

			if is_medres_manager(current_user)

				@scholarship.medres=true

			end

    end

    # Only allow a trusted parameter "white list" through.
    def scholarship_params
      params.require(:scholarship).permit(:amount, :writtenform, :name, :start, :finish, :writtenformpartial, :pap, :medres, :comment, :partialamount, :daystarted, :dayfinished )
    end
end
