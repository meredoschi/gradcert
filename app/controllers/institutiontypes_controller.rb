class InstitutiontypesController < ApplicationController
  before_action :set_institutiontype, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user!
  
  # Marcelo - CanCan
	load_and_authorize_resource 

  # GET /institutiontypes
  # GET /institutiontypes.json
  def index
  
    @title="Relação de tipos de instituições"
    @institutiontypes = Institutiontype.page(params[:page]).per(25)
#   @institutiontypes = Institutiontype.all
		@numinstitutiontypes=Institutiontype.count

  end

  # GET /institutiontypes/1
  # GET /institutiontypes/1.json
  def show
    @title="Mostrando tipo da instituição"
  end

  # GET /institutiontypes/new
  def new
    @title="Novo tipo de instituição"
    @institutiontype = Institutiontype.new
  end

  # GET /institutiontypes/1/edit
  def edit
  end

  # POST /institutiontypes
  # POST /institutiontypes.json
  def create
    @institutiontype = Institutiontype.new(institutiontype_params)

    respond_to do |format|
      if @institutiontype.save
        format.html { redirect_to @institutiontype, notice: 'Tipo de instituição foi criado com sucesso.' }
        format.json { render action: 'show', status: :created, location: @institutiontype }
      else
        format.html { render action: 'new' }
        format.json { render json: @institutiontype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /institutiontypes/1
  # PATCH/PUT /institutiontypes/1.json
  def update
    respond_to do |format|
      if @institutiontype.update(institutiontype_params)
        format.html { redirect_to @institutiontype, notice: 'Tipo de instituição foi atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @institutiontype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /institutiontypes/1
  # DELETE /institutiontypes/1.json
  def destroy
    @institutiontype.destroy
    respond_to do |format|
      format.html { redirect_to institutiontypes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_institutiontype
      @institutiontype = Institutiontype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def institutiontype_params
      params.require(:institutiontype).permit(:name)
    end
end
