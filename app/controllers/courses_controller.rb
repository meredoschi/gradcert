class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /courses
  def index
    
    @title=t('course').pluralize.mb_chars.upcase+" | "+t('activerecord.models.course').pluralize.capitalize

    @search = Course.ransack(params[:q])
    @courses=@search.result.page(params[:page]).per(10)

		@numcourses=Course.count


  end

  # GET /courses/1
  def show
  
   	@title=t('course').pluralize.upcase.pluralize.mb_chars.upcase+" | "+t('activerecord.models.course').capitalize+" | "+t('actions.show')

  end

  # GET /courses/new
  def new

    @course = Course.new
    @course.build_address
        
    if is_admin_or_manager(current_user)
  	 	
	   	 @title=t('course').pluralize.upcase+' | '+tm('course').pluralize.capitalize+' | '+t('actions.new.f')  

		else

			 @title=t('my.f').upcase+" "+t('course').upcase+' | '+tm('course').capitalize+' | '+t('actions.new.f')		 
		 
		end   
    
  end

  # GET /courses/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.course')

    if is_admin_or_manager(current_user) 

				@title=t('course').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.course')

    	else

			if is_local_admin(current_user) 

				@title=t('course').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.course')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('course').pluralize

			end
  	
  	end

  end

  # POST /courses
  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to @course, notice: t('activerecord.models.course').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /courses/1
  def update
    if @course.update(course_params)
     # redirect_to @course, notice: 'Course was successfully updated.'
       redirect_to @course, notice: t('activerecord.models.course').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /courses/1
  def destroy
    @course.destroy
    redirect_to courses_url, notice: t('activerecord.models.course').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.require(:course).permit(:id, :program_id, :coursename_id, :workload, :methodology_id, :profession_id, :practical, :core, :professionalrequirement, :supervisor_id,  :syllabus, address_attributes: [:id, :header, :municipality_id, :streetname_id, :country_id, :postalcode, :addr, :complement, :neighborhood, :course_id, :internal])
		  # params.require(:course).permit!        
    end
end
