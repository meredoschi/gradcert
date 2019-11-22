# frozen_string_literal: true

# Originally based on "CBO - Classificação Brasileira de Ocupações"
class ProfessionsController < ApplicationController
  before_action :set_profession, only: %i[show edit update destroy]

  # GET /professions
  # GET /professions.json
  def index
    #  @professions = Profession.all

    @title = t('definition').pluralize.mb_chars.upcase + ' | ' + t('activerecord.models.
      profession').pluralize.capitalize

    @search = Profession.accessible_by(current_ability).ransack(params[:q])
    @professions = @search.result.page(params[:page]).per(10)
    @numprofessions = Profession.count
    @numprofessionalfamilies = Professionalfamily.count
  end

  # GET /professions/1
  # GET /professions/1.json
  def show
    @title = t('definition').pluralize.mb_chars.upcase + ' | ' + t('activerecord.models.
      profession').capitalize + ' | ' + t('actions.show')
  end

  # GET /professions/new
  def new
    @profession = Profession.new
    @title = t('definition').pluralize.mb_chars.upcase + ' | ' + t('activerecord.models.
      profession').pluralize.capitalize + ' | ' + t('actions.new.f')
  end

  # GET /professions/1/edit
  def edit
    @title = t('definition').pluralize.mb_chars.upcase + ' | ' + t('activerecord.models.
      profession').capitalize + ' | ' + t('actions.edit')
  end

  # POST /professions
  # POST /professions.json
  def create
    @profession = Profession.new(profession_params)

    respond_to do |format|
      if @profession.save
        # format.html { redirect_to @profession, notice: 'Profession was successfully created.' }
        format.html do
          redirect_to @profession, notice: t('activerecord.models.
          profession').capitalize + ' ' + t('created.f') + ' ' + t('succesfully')
        end

        format.json { render action: 'show', status: :created, location: @profession }
      else
        format.html { render action: 'new' }
        format.json { render json: @profession.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professions/1
  # PATCH/PUT /professions/1.json
  def update
    respond_to do |format|
      if @profession.update(profession_params)
        format.html do
          redirect_to @profession, notice: t('activerecord.models.
          profession').capitalize + ' ' + t('updated.f') + ' ' + t('succesfully')
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @profession.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professions/1
  # DELETE /professions/1.json
  def destroy
    @profession.destroy
    respond_to do |format|
      format.html { redirect_to professions_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profession
    @profession = Profession.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profession_params
    params.require(:profession).permit(:name, :occupationcode, :pap, :medres,
                                       :professionalfamily_id)
  end
end
