class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user!

  # Marcelo - CanCan
	load_and_authorize_resource

  # GET /roles
  # GET /roles.json
  def index

    @title=t('system').mb_chars.upcase+" | "+t('activerecord.models.role').capitalize.pluralize

#     @roles = Role.page(params[:page]).per(10)

	  @search = Role.accessible_by(current_ability).ransack(params[:q])
  	@roles=@search.result.page(params[:page]).per(10)
		@numroles=Role.count


  end

  # GET /roles/1
  # GET /roles/1.json
  def show
		@title=t('system').upcase+" | "+t('activerecord.models.role').capitalize+": "+@role.name

  end

  # GET /roles/new
  def new
    @title=t('system').upcase+' | '+tm('role').pluralize.capitalize+' | '+t('actions.new.m')

    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
  		@title=t('system').upcase+" | "+t('noun.edit')+" "+t('activerecord.models.role')

  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: t('activerecord.models.role').titleize+' '+t('created.m')+' '+t('succesfully') }
        format.json { render action: 'show', status: :created, location: @role }
      else
        format.html { render action: 'new' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: t('activerecord.models.role').titleize+' '+t('updated.m')+'.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :management, :teaching, :clerical, :pap, :medres, :collaborator, :student, :itstaff)
    end
end
