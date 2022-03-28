class MakeupschedulesController < ApplicationController
  before_action :set_makeupschedule, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

  # GET /makeupschedules
  def index
#    @makeupschedules = Makeupschedule.all

		@title=t('list')+' '+t('activerecord.models.makeupschedule').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.makeupschedule').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.makeupschedule').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('makeupschedule').pluralize.upcase

  		end

    end

    @all_makeupschedules=Makeupschedule.includes(registration: {student: [contact: :user]})
    @accessible_makeupschedules=@all_makeupschedules.accessible_by(current_ability)
  	@search = @accessible_makeupschedules.ransack(params[:q])

  	@makeupschedules=@search.result.page(params[:page]).per(10)
		@nummakeupschedules=@accessible_makeupschedules.count

  end

  # GET /makeupschedules/1
  def show
  	@title=t('activerecord.models.makeupschedule').capitalize

#  	if !@makeupschedule.name.nil?

#    	@title=@title+": "+@makeupschedule.name

#     end

  	if is_admin_or_manager(current_user)

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.makeupschedule').capitalize+": "+@makeupschedule.name

    else

 	 		if is_local_admin(current_user)

				@title=t('navbar_menu_name').to_s.upcase+' | '+t('activerecord.models.makeupschedule').capitalize

			else

				@title=tm('makeupschedule').pluralize.upcase

				if !@makeupschedule.name.nil?

					@title+=" : "+@makeupschedule.name

				end

			end

		end

  end

  # GET /makeupschedules/new
  def new
    @makeupschedule = Makeupschedule.new

    if is_admin_or_manager(current_user)

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.makeupschedule')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.makeupschedule')

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.makeupschedule')

			end

		end

  end

  # GET /makeupschedules/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.makeupschedule')

    if is_admin_or_manager(current_user)

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.makeupschedule')

    	else

			if is_local_admin(current_user)

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.makeupschedule')

			else

 			  @title=t('noun.edit')+' '+tm('makeupschedule').pluralize

			end

  	end

  end

  # POST /makeupschedules
  def create
    @makeupschedule = Makeupschedule.new(makeupschedule_params)

    if @makeupschedule.save
      redirect_to @makeupschedule, notice: t('activerecord.models.makeupschedule').capitalize+' '+t('created.m')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /makeupschedules/1
  def update
    if @makeupschedule.update(makeupschedule_params)
     # redirect_to @makeupschedule, notice: 'Makeupschedule was successfully updated.'
       redirect_to @makeupschedule, notice: t('activerecord.models.makeupschedule').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /makeupschedules/1
  def destroy
    @makeupschedule.destroy
    redirect_to makeupschedules_url, notice: t('activerecord.models.makeupschedule').capitalize+' '+t('deleted.m')+' '+t('succesfully')

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_makeupschedule
      @makeupschedule = Makeupschedule.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def makeupschedule_params
      params.require(:makeupschedule).permit(:start, :finish, :registration_id)
    end
end
