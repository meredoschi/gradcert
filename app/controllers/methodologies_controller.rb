class MethodologiesController < ApplicationController
  before_action :set_methodology, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /methodologies
  def index
  
    @title=t('definition').pluralize.mb_chars.upcase+" | "+t('activerecord.models.methodology').pluralize.capitalize

    @search = Methodology.ransack(params[:q])
    @methodologies=@search.result.page(params[:page]).per(10)

		@nummethodologies=Methodology.count

  end
       

  # GET /methodologies/1
  def show
  	
  	@title=t('activerecord.models.methodology')
   	@title=t('definition').pluralize.mb_chars.upcase+" | "+t('activerecord.models.methodology').capitalize+" | "+t('actions.show')


  end

  # GET /methodologies/new
  def new
    @methodology = Methodology.new

    if is_admin_or_manager(current_user)
    
			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.f')+" "+t('activerecord.models.methodology')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.methodology')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.methodology')  			
			
			end

		end
    
  end

  # GET /methodologies/1/edit
  def edit
	  
	  @title=t('actions.edit')+" "+t('activerecord.models.methodology')
   	@title=t('definition').pluralize.mb_chars.upcase+" | "+t('activerecord.models.methodology').capitalize+" | "+t('actions.edit')

  end

  # POST /methodologies
  def create
    @methodology = Methodology.new(methodology_params)

    if @methodology.save
      redirect_to @methodology, notice: t('activerecord.models.methodology').capitalize+' '+t('created.f')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /methodologies/1
  def update
    if @methodology.update(methodology_params)
     # redirect_to @methodology, notice: 'Methodology was successfully updated.'
       redirect_to @methodology, notice: t('activerecord.models.methodology').capitalize+' '+t('updated.f')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /methodologies/1
  def destroy
    @methodology.destroy
    redirect_to methodologies_url, notice: t('activerecord.models.methodology').capitalize+' '+t('deleted.f')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_methodology
      @methodology = Methodology.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def methodology_params
      params.require(:methodology).permit(:kind)
    end
end
