class ProgramnamesController < ApplicationController
  before_action :set_programname, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user!

  # Marcelo - CanCan
	load_and_authorize_resource

  # GET /programnames
  # GET /programnames.json
  def index

   	@title=t('definition').pluralize.mb_chars.upcase+" | "+t('activerecord.models.programname').pluralize.capitalize

    @search = Programname.ransack(params[:q])
    @programnames=@search.result.page(params[:page]).per(10)

		@numprogramnames=Programname.count
#     @programnames = Programname.all
  end

  # GET /programnames/1
  # GET /programnames/1.json
  def show
      @title=t('activerecord.models.programname')
   		@title=t('definition').pluralize.mb_chars.upcase+" | "+t('activerecord.models.programname').capitalize+" | "+t('actions.show')

      if @programname.ancestor_id.present?

        @ancestor=Programname.find @programname.ancestor_id

      else

        @ancestor=nil

      end

	end

  # GET /programnames/new
  def new

  	@title=t('definition').pluralize.mb_chars.upcase+" | "+t('activerecord.models.programname').capitalize+" | "+t('actions.new.m')
    @programname = Programname.new

  end

  # GET /programnames/1/edit
  def edit
     @title=t('actions.edit')+" "+t('activerecord.models.program')
   	 @title=t('definition').pluralize.mb_chars.upcase+" | "+t('activerecord.models.programname').capitalize+" | "+t('actions.edit')

  end

  # POST /programnames
  # POST /programnames.json
  def create

    @programname = Programname.new(programname_params)

    set_sector

    respond_to do |format|
      if @programname.save
        format.html { redirect_to @programname, notice: t('activerecord.models.programname')+' '+t('created.m')+' '+t('succesfully') }
	      format.json { render action: 'show', status: :created, location: @programname }
      else
        format.html { render action: 'new' }
        format.json { render json: @programname.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /programnames/1
  # PATCH/PUT /programnames/1.json
  def update

    set_sector

    respond_to do |format|
      if @programname.update(programname_params)
        format.html { redirect_to @programname, notice: t('activerecord.models.programname').capitalize+' '+t('updated.m')+' '+t('succesfully') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @programname.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programnames/1
  # DELETE /programnames/1.json
  def destroy
    @programname.destroy
    respond_to do |format|
      format.html { redirect_to programnames_url }
      format.json { head :no_content }
		end

	 rescue ActiveRecord::DeleteRestrictionError

    respond_to do |format|
      format.html { redirect_to @programname, alert: t('activerecord.errors.delete_restriction') }
      format.json { head :no_content }
		end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_programname
      @programname = Programname.find(params[:id])
    end

    # Applies to managers only
    def set_sector

      if is_pap_manager(current_user)

        @programname.pap=true

      end

      if is_medres_manager(current_user)

        @programname.medres=true

      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def programname_params
      params.require(:programname).permit(:name, :previousname, :pap, :medres, :active, :comment, :legacy, :ancestor_id)
    end
end
