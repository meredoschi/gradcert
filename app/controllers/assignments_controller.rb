class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user!

 # Marcelo - CanCan
	load_and_authorize_resource 

  # GET /assignments
  # GET /assignments.json
  def index
#     @assignments = Assignment.all

    if is_regular_user(current_user)    

			@title=t('my.f').upcase+' '+t('navbar.programming').upcase+' | '+tm('assignment').capitalize
    
    else

			@title=t('navbar.programming').pluralize.upcase+' | '+tm('assignment').pluralize.capitalize
    
    end
    
  	@search = Assignment.accessible_by(current_ability).ransack(params[:q])
  	@assignments=@search.result.page(params[:page]).per(10)
		@numassignments=Assignment.accessible_by(current_ability).count
    
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show

		if is_regular_user(current_user)

			@title=t('my.f').upcase+' '+t('navbar.programming').upcase+' | '+tm('assignment').capitalize+' | '+t('actions.show')
  
		else
		
			@title=t('navbar.programming').pluralize.upcase+' | '+tm('assignment').capitalize+' | '+t('actions.show')
	
		end
  				
  end

  # GET /assignments/new
  def new
    @assignment = Assignment.new
    
    if is_admin_or_manager(current_user)
  	 	
	   	 @title=t('navbar.programming').pluralize.upcase+' | '+tm('assignment').pluralize.capitalize+' | '+t('actions.new.f')  

		else

			 @title=t('my.f').upcase+" "+t('navbar.programming').upcase+' | '+tm('assignment').capitalize+' | '+t('actions.new.f')		 
		 
		end   

  end

  # GET /assignments/1/edit
  def edit
 
		if is_regular_user(current_user)

			@title=t('my.f').upcase+' '+t('navbar.programming').upcase+' | '+tm('assignment').capitalize+' | '+t('actions.edit')
		
		
		else

			@title=t('navbar.programming').pluralize.upcase+' | '+tm('assignment').capitalize+' | '+t('actions.edit')


		end
  		
  
  end

  # POST /assignments
  # POST /assignments.json
  def create
    @assignment = Assignment.new(assignment_params)


    respond_to do |format|
      if @assignment.save
        format.html { redirect_to @assignment, notice: t('activerecord.models.assignment').capitalize+' '+t('created.f')+' '+t('succesfully') }
        format.json { render action: 'show', status: :created, location: @assignment }
      else
        format.html { render action: 'new' }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1
  # PATCH/PUT /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to @assignment, notice: t('activerecord.models.assignment').capitalize+' '+t('updated.f')+' '+t('succesfully') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:program_id, :supervisor_id, :start_date, :main)
    end
end
