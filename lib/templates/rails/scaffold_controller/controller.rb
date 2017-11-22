<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
#  <%= class_name %> - Controller
class <%= controller_class_name %>Controller < ApplicationController
  #	before_filter :authenticate_user! # By default... Devise

  #	load_and_authorize_resource  # CanCan(Can)

  # GET <%= route_url %>
  def index
    @title = '<%= class_name %>' + '- index view'
    @<%= plural_table_name %> = <%= class_name %>.all

    #   @search = <%= class_name %>.accessible_by(current_ability).ransack(params[:q])
    #   @<%= plural_table_name %> = @search.result.page(params[:page]).per(10)
    @num<%= plural_table_name %> = <%= class_name %>.count
  end

  # GET <%= route_url %>/1
  def show
    @title = '<%= class_name %>' + '- show view'
  end

  # GET <%= route_url %>/new
  def new
    @title = '<%= class_name %>' + '- new'
  end

  # GET <%= route_url %>/1/edit
  def edit
    @title = '<%= class_name %>' + '- edit'
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    if @<%= orm_instance.save %>
      <%= singular_table_name %>_i18n = t('activerecord.models.<%= singular_table_name %>').capitalize
      redirect_to @<%= singular_table_name %>, notice: <%= singular_table_name %>_i18n + ' ' + t('created.m') + ' ' + t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      <%= singular_table_name %>_i18n = t('activerecord.models.<%= singular_table_name %>').capitalize
      redirect_to @<%= singular_table_name %>, notice: <%= singular_table_name %>_i18n + ' ' + t('updated.m') + ' ' + t('succesfully')
    else
      render :edit
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    <%= singular_table_name %>_i18n = t('activerecord.models.<%= singular_table_name %>').capitalize
    redirect_to <%= index_helper %>_url, notice: <%= singular_table_name %>_i18n + ' ' + t('deleted.m') + ' ' + t('succesfully')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
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
