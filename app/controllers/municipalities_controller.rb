class MunicipalitiesController < ApplicationController
  before_action :set_municipality, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user!
  
  # Marcelo - CanCan
	load_and_authorize_resource 

	
  # GET /municipalities
  # GET /municipalities.json
  def index
  	 @title="Relação de municípios"
    # @municipalities = Municipality.page(params[:page]).per(20)
    # 	 @municipalities = Municipality.paulista.page(params[:page]).per(10)

  		@search = Municipality.ransack(params[:q])
  		@municipalities=@search.result.page(params[:page]).per(10)
			@nummunicipalities=Municipality.count
			@numinstitutions=Municipality.with_institution.count

  end

  # GET /municipalities/1
  # GET /municipalities/1.json
  def show
  	 @title="Mostrando detalhes do município"  
  	 @cityinstitutions=@municipality.address.institution.page(params[:page]).per(10)
  end

  # GET /municipalities/new
  def new

  	 @title="Novo município"  
    @municipality = Municipality.new
  end

  # GET /municipalities/1/edit
  def edit
  	 @title="Edição de município"  
  end

  # POST /municipalities
  # POST /municipalities.json
  def create
    @municipality = Municipality.new(municipality_params)

    respond_to do |format|
      if @municipality.save
        format.html { redirect_to @municipality, notice: 'Município criado com sucesso.' }
        format.json { render action: 'show', status: :created, location: @municipality }
      else
        format.html { render action: 'new' }
        format.json { render json: @municipality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /municipalities/1
  # PATCH/PUT /municipalities/1.json
  def update
    respond_to do |format|
      if @municipality.update(municipality_params)
        format.html { redirect_to @municipality, notice: 'Município atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @municipality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /municipalities/1
  # DELETE /municipalities/1.json
  def destroy
    @municipality.destroy
    respond_to do |format|
      format.html { redirect_to municipalities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_municipality
      @municipality = Municipality.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def municipality_params
      params.require(:municipality).permit(:name, :stateregion_id, :capital, :regionaloffice_id)
    end
end
