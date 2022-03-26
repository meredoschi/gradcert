class AdmissionsController < ApplicationController

  before_action :set_admission, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!

  # Marcelo - CanCan
	load_and_authorize_resource

  def index

    @title=t('list')+' '+t('activerecord.models.admission').pluralize

    @all_admissions = Admission.ordered_by_schoolterm_desc_programname_institution

    @admissions_for_current_ability=@all_admissions.accessible_by(current_ability)

    @numadmissions=@admissions_for_current_ability.count

    # http://stackoverflow.com/questions/27890997/ransack-return-records-with-boolean-attribute-both-true-and-false-with-checkbox

    @search = @admissions_for_current_ability.ransack(params[:q])

    @admissions_without_pagination=@search.result

    @admissions=@admissions_without_pagination.page(params[:page]).per(10)

  end

  def edit
    @title=t('course').pluralize.upcase+' | '+tm('admission').capitalize+' | '+t('actions.edit')

    @program=@admission.program # for header

  end

  def update

    @program=@admission.program # for header

    respond_to do |format|

      if @admission.update(admission_params)
        format.html { redirect_to @admission, notice: t('activerecord.models.admission').capitalize+' '+t('updated.m')+' '+t('succesfully') }

        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admission.errors, status: :unprocessable_entity }
      end
    end

  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admission
      @admission = Admission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admission_params

         params.require(:admission).permit(:id, :start, :finish, :candidates, :absentfirstexam, :absentfinalexam, :passedfirstexam, :appealsgrantedfirstexam, :appealsdeniedfirstexam, :appealsgrantedfinalexam, :appealsdeniedfinalexam,  :admitted, :convoked, :program_id, :grantsasked, :grantsgiven, :accreditedgrants, :insufficientfinalexamgrade)

    end
end
