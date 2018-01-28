class LeavetypesController < ApplicationController
  before_action :set_leavetype, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

  # GET /leavetypes
  def index
    @leavetypes = Leavetype.all

		@title=t('list')+' '+t('activerecord.models.leavetype').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase
      @title+=' | '+t('activerecord.models.leavetype').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('navbar.financial').upcase
        @title+=' | '+t('activerecord.models.leavetype').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('leavetype').pluralize.upcase

  		end

    end


  	@search = Leavetype.accessible_by(current_ability).ransack(params[:q])
  	@leavetypes=@search.result.page(params[:page]).per(10)
		@numleavetypes=Leavetype.count

  end

  # GET /leavetypes/1
  def show
  	@title=t('activerecord.models.leavetype').capitalize

#  	if !@leavetype.name.nil?

#    	@title=@title+": "+@leavetype.name

#     end

  	if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase+" | "+t('activerecord.models.leavetype').capitalize+": "+@leavetype.name

    else

 	 		if is_local_admin(current_user)

				@title=t('navbar_menu_name').mb_chars.upcase+' | '+t('activerecord.models.leavetype').capitalize

			else

				@title=tm('leavetype').pluralize.upcase

				if !@leavetype.name.nil?

					@title+=" : "+@leavetype.name

				end

			end

		end

  end

  # GET /leavetypes/new
  def new
    @leavetype = Leavetype.new

    if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.leavetype')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.leavetype')

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.leavetype')

			end

		end


  end

  # GET /leavetypes/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.leavetype')

    if is_admin_or_manager(current_user)

				@title=t('navbar.financial').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.leavetype')

    	else

			if is_local_admin(current_user)

				@title=t('navbar.financial').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.leavetype')

			else

 			  @title=t('noun.edit')+' '+tm('leavetype').pluralize

			end

  	end

  end

  # POST /leavetypes
  def create
    @leavetype = Leavetype.new(leavetype_params)

		set_sector

    if @leavetype.save
      redirect_to @leavetype, notice: t('activerecord.models.leavetype').capitalize+' '+t('created.m')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /leavetypes/1
  def update
    if @leavetype.update(leavetype_params)
     # redirect_to @leavetype, notice: 'Leavetype was successfully updated.'
       redirect_to @leavetype, notice: t('activerecord.models.leavetype').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /leavetypes/1
  def destroy
    @leavetype.destroy
    redirect_to leavetypes_url, notice: t('activerecord.models.leavetype').capitalize+' '+t('deleted.m')+' '+t('succesfully')

  end

  private

	# Applies to managers only
   def set_sector

			if is_pap_manager(current_user)

				@leavetype.pap=true

			end

			if is_medres_manager(current_user)

				@leavetype.medres=true

			end

   end

    # Use callbacks to share common setup or constraints between actions.
    def set_leavetype
      @leavetype = Leavetype.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def leavetype_params
      params.require(:leavetype).permit(:name, :paid, :comment, :setnumdays, :dayspaidcap, :pap, :medres, :maxnumdays, :vacation)
    end
end
