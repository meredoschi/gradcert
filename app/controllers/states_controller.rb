class StatesController < ApplicationController
  before_action :set_state, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user!

  # Marcelo - CanCan
	load_and_authorize_resource


  # GET /states
  # GET /states.json
  def index
    # @states = State.all

#     @title="Relação de estados (UFs)"

    @title=t('activerecord.models.state').capitalize.pluralize

  	@search = State.accessible_by(current_ability).ransack(params[:q])
  	@states=@search.result.page(params[:page]).per(10)
		@numstates=State.count

  end

  # GET /states/1
  # GET /states/1.json
  def show
      @title=t('activerecord.models.state').capitalize

      if !@state.name.nil?

      	@title=@title+": "+@state.name

      end

      @stateregions=@state.stateregion.page(params[:page]).per(10)

      @country=@state.country

  end

  # GET /states/new
  def new
    @state = State.new
#   @title="Novo estado"
    @title=t('actions.new.f')+" "+t('activerecord.models.state')

  end

  # GET /states/1/edit
  def edit
#     @title="Edição de estado (UF)"
    @title=t('actions.edit')+t('activerecord.models.state')

  end

  # POST /states
  # POST /states.json
  def create
    @state = State.new(state_params)

    respond_to do |format|
      if @state.save
        format.html { redirect_to @state, notice: t('activerecord.models.state').capitalize+' '+t('created.m')+' '+t('succesfully') }

        format.json { render action: 'show', status: :created, location: @state }
      else
        format.html { render action: 'new' }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /states/1
  # PATCH/PUT /states/1.json
  def update
    respond_to do |format|
      if @state.update(state_params)
        format.html { redirect_to @state, notice: t('activerecord.models.state').capitalize+' '+t('updated.m')+' '+t('succesfully') }

        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.json
  def destroy
    @state.destroy
    respond_to do |format|
      format.html { redirect_to states_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_state
      @state = State.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def state_params
      params.require(:state).permit(:id, :name, :abbreviation, :country_id)
    end
end
