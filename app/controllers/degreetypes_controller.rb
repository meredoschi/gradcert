class DegreetypesController < ApplicationController
  before_action :set_degreetype, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

  # GET /degreetypes
  def index

   	@title=t('definition').pluralize.to_s.upcase+" | "+t('activerecord.models.degreetype').pluralize.capitalize

    @search = Degreetype.ransack(params[:q])
    @degreetypes=@search.result.page(params[:page]).per(10)
		@numdegreetypes=Degreetype.count


  end

  # GET /degreetypes/1
  def show

      @title=t('activerecord.models.degreetype')
   		@title=t('definition').pluralize.to_s.upcase+" | "+t('activerecord.models.degreetype').capitalize+" | "+t('actions.show')

  end

  # GET /degreetypes/new
  def new

  	@title=t('definition').pluralize.to_s.upcase+" | "+t('activerecord.models.degreetype').capitalize+" | "+t('actions.new.m')
    @degreetype = Degreetype.new

  end

  # GET /degreetypes/1/edit
  def edit

 		@title=t('actions.edit')+" "+t('activerecord.models.degreetype')
   	@title=t('definition').pluralize.to_s.upcase+" | "+t('activerecord.models.degreetype').capitalize+" | "+t('actions.edit')


  end

  # POST /degreetypes
  def create
    @degreetype = Degreetype.new(degreetype_params)

    if @degreetype.save
      redirect_to @degreetype, notice: t('activerecord.models.degreetype').capitalize+' '+t('created.m')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /degreetypes/1
  def update
    if @degreetype.update(degreetype_params)
     # redirect_to @degreetype, notice: 'Degreetype was successfully updated.'
       redirect_to @degreetype, notice: t('activerecord.models.degreetype').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /degreetypes/1
  def destroy
    @degreetype.destroy
    redirect_to degreetypes_url, notice: t('activerecord.models.degreetype').capitalize+' '+t('deleted.m')+' '+t('succesfully')

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_degreetype
      @degreetype = Degreetype.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def degreetype_params
      params.require(:degreetype).permit(:name, :level, :pap, :medres)
    end
end
