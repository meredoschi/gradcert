# frozen_string_literal: true

# Permissions should be seeded
class PermissionsController < ApplicationController
  before_action :set_permission, only: %i[show edit update destroy]

  before_action :authenticate_user!

  # Marcelo - CanCan
  load_and_authorize_resource

  # GET /permissions
  # GET /permissions.json
  def index
    @title = t('system').to_s.upcase + ' | ' + \
             t('activerecord.models.permission').capitalize.pluralize

    @search = Permission.accessible_by(current_ability).ordered_by_kind.ransack(params[:q])
    @permissions = @search.result.page(params[:page]).per(10)
    @numpermissions = Permission.count
  end

  # GET /permissions/1
  # GET /permissions/1.json
  def show
    @title = t('system').to_s.upcase + ' | ' + t('activerecord.models.permission').capitalize

    @title = @title + ': ' + @permission.description unless @permission.description.nil?
  end

  # GET /permissions/new
  def new
    @permission = Permission.new

    @title = t('system').to_s.upcase + ' | ' + \
             t('activerecord.models.permission').pluralize.capitalize + ' | ' + t('actions.new.f')
  end

  # GET /permissions/1/edit
  def edit
    @title = t('system').upcase + ' | ' + t('noun.edit') + ' ' + t('activerecord.models.permission')
  end

  # POST /permissions
  # POST /permissions.json
  def create
    @permission = Permission.new(permission_params)

    respond_to do |format|
      if @permission.save
        format.html do
          redirect_to @permission, notice: t('activerecord.models.permission')
            .capitalize + ' ' + t('created.f') + ' ' + t('succesfully')
        end
        format.json { render action: 'show', status: :created, location: @permission }
      else
        format.html { render action: 'new' }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permissions/1
  # PATCH/PUT /permissions/1.json
  def update
    respond_to do |format|
      if @permission.update(permission_params)
        format.html do
          redirect_to @permission, notice: t('activerecord.models.permission')
            .capitalize + ' ' + t('updated.f') + ' ' + t('succesfully')
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.json
  def destroy
    @permission.destroy
    respond_to do |format|
      format.html { redirect_to permissions_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_permission
    @permission = Permission.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def permission_params
    params.require(:permission).permit(:kind, :description)
  end
end
