class StreetnamesController < ApplicationController
  before_action :set_streetname, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user!
  
  # Marcelo - CanCan
	load_and_authorize_resource 

  # GET /streetnames
  # GET /streetnames.json
  def index
    @title="Relação de logradouros"
#     @streetnames = Streetname.all
  	@streetnames=Streetname.page(params[:page]).per(10)
  	@numstreetnames=Streetname.count

  end

  # GET /streetnames/1
  # GET /streetnames/1.json
  def show
        @title="Mostrando tipo de logradouro"
  end

  # GET /streetnames/new
  def new
    @title="Novo tipo de logradouro"
    @streetname = Streetname.new
  end

  # GET /streetnames/1/edit
  def edit
 	  @title="Edição de tipo de logradouro"
  end

  # POST /streetnames
  # POST /streetnames.json
  def create
    @streetname = Streetname.new(streetname_params)

    respond_to do |format|
      if @streetname.save
        format.html { redirect_to @streetname, notice: 'Logradouro foi criado com sucesso.' }
        format.json { render action: 'show', status: :created, location: @streetname }
      else
        format.html { render action: 'new' }
        format.json { render json: @streetname.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /streetnames/1
  # PATCH/PUT /streetnames/1.json
  def update
    respond_to do |format|
      if @streetname.update(streetname_params)
        format.html { redirect_to @streetname, notice: 'Tipo de logradouro editado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @streetname.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /streetnames/1
  # DELETE /streetnames/1.json
  def destroy
    @streetname.destroy
    respond_to do |format|
      format.html { redirect_to streetnames_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_streetname
      @streetname = Streetname.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def streetname_params
      params.require(:streetname).permit(:designation)
    end
end
