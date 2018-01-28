class StateregionsController < ApplicationController
  before_action :set_stateregion, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user!
  
  # Marcelo - CanCan
	load_and_authorize_resource 

  # GET /stateregions
  # GET /stateregions.json
  def index
		@title="Relação de regiões estaduais"
#   @stateregions = Stateregion.all
#    @stateregions = Stateregion.paulista.page(params[:page]).per(10)

  	@search = Stateregion.accessible_by(current_ability).ransack(params[:q])
  	@stateregions=@search.result.page(params[:page]).per(10)
		@numstateregions=Stateregion.count

  end

  # GET /stateregions/1
  # GET /stateregions/1.json
  def show
     @title="Detalhes da região estadual"
  	 @stateregionmunicipalities=@stateregion.municipality.page(params[:page]).per(10)

  end

  # GET /stateregions/new
  def new
    @title="Nova região estadual"
		@stateregion = Stateregion.new

  end

  # GET /stateregions/1/edit
  def edit
		@title="Edição de região estadual"		  
  end

  # POST /stateregions
  # POST /stateregions.json
  def create
    @stateregion = Stateregion.new(stateregion_params)

    respond_to do |format|
      if @stateregion.save
        format.html { redirect_to @stateregion, notice: 'Região estadual criada com sucesso.' }
        format.json { render action: 'show', status: :created, location: @stateregion }
      else
        format.html { render action: 'new' }
        format.json { render json: @stateregion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stateregions/1
  # PATCH/PUT /stateregions/1.json
  def update
    respond_to do |format|
      if @stateregion.update(stateregion_params)
        format.html { redirect_to @stateregion, notice: 'Região estadual atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @stateregion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stateregions/1
  # DELETE /stateregions/1.json
  def destroy
    @stateregion.destroy
    respond_to do |format|
      format.html { redirect_to stateregions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stateregion
      @stateregion = Stateregion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stateregion_params
      params.require(:stateregion).permit(:name, :brstate_id)
    end
end
