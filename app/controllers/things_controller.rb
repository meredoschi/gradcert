#  Thing - Controller
class ThingsController < ApplicationController
  #	before_filter :authenticate_user! # By default... Devise

  #	load_and_authorize_resource  # CanCan(Can)

  # GET /things
  def index
    @title = 'Thing' + '- index view'
    @things = Thing.all

    #   @search = Thing.accessible_by(current_ability).ransack(params[:q])
    #   @things = @search.result.page(params[:page]).per(10)
    @numthings = Thing.count
  end

  # GET /things/1
  def show
    @title = 'Thing' + '- show view'
  end

  # GET /things/new
  def new
    @title = 'Thing' + '- new'
  end

  # GET /things/1/edit
  def edit
    @title = 'Thing' + '- edit'
  end

  # POST /things
  def create
    @thing = Thing.new(thing_params)

    if @thing.save
      thing_i18n = t('activerecord.models.thing').capitalize
      redirect_to @thing, notice: thing_i18n + ' ' + t('created.m') + ' ' + t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /things/1
  def update
    if @thing.update(thing_params)
      thing_i18n = t('activerecord.models.thing').capitalize
      redirect_to @thing, notice: thing_i18n + ' ' + t('updated.m') + ' ' + t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /things/1
  def destroy
    @thing.destroy
    thing_i18n = t('activerecord.models.thing').capitalize
    redirect_to things_url, notice: thing_i18n + ' ' + t('deleted.m') + ' ' + t('succesfully')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # Use callbacks to share common setup or constraints between actions.
  def set_thing
    @thing = Thing.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def thing_params
    params.require(:thing).permit(:name)
  end
end
