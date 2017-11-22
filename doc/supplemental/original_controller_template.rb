# lib/templates/rails/scaffold_controller/controller.rb
<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>

		@title=t('list')+' '+t('activerecord.models.<%= singular_table_name %>').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.<%= singular_table_name %>').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.<%= singular_table_name %>').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('<%= singular_table_name %>').pluralize.upcase
    		
  		end
  		  
    end
       

  	@search = <%= class_name %>.accessible_by(current_ability).ransack(params[:q])
  	@<%= plural_table_name %>=@search.result.page(params[:page]).per(10)
		@num<%= plural_table_name %>=<%= class_name %>.count

  end

  # GET <%= route_url %>/1
  def show
  	@title=t('activerecord.models.<%= singular_table_name %>').capitalize   
 
#  	if !@<%= singular_table_name %>.name.nil?
    
#    	@title=@title+": "+@<%= singular_table_name %>.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.<%= singular_table_name %>').capitalize+": "+@<%= singular_table_name %>.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar_menu_name').mb_chars.upcase+' | '+t('activerecord.models.<%= singular_table_name %>').capitalize
  			
			else
					
				@title=tm('<%= singular_table_name %>').pluralize.upcase

				if !@<%= singular_table_name %>.name.nil? 
				
					@title+=" : "+@<%= singular_table_name %>.name
				
				end	
				
			end
			
		end

  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>

    if is_admin_or_manager(current_user)
    
			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.<%= singular_table_name %>')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.<%= singular_table_name %>')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.<%= singular_table_name %>')  			
			
			end

		end
    
  end

  # GET <%= route_url %>/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.<%= singular_table_name %>')

    if is_admin_or_manager(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.<%= singular_table_name %>')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.<%= singular_table_name %>')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('<%= singular_table_name %>').pluralize

			end
  	
  	end

  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: t('activerecord.models.<%= singular_table_name %>').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
     # redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully updated.'" %>
       redirect_to @<%= singular_table_name %>, notice: t('activerecord.models.<%= singular_table_name %>').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url, notice: t('activerecord.models.<%= singular_table_name %>').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>
