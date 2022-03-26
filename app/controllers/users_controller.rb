# frozen_string_literal: true

# All users have contact information associated with them, some may also be students
class UsersController < ApplicationController
  before_action :authenticate_user!

  # Marcelo - CanCan
  load_and_authorize_resource

  def index
    @title = if is_staff(current_user)

               t('people').upcase + ' | ' + tm('user').mb_chars.pluralize.capitalize

             else

               # i.e. regular user or collaborator

               t('personal_info').mb_chars.upcase + ' | ' + t('my.m').capitalize + \
                 ' ' + t('activerecord.models.user')

             end

    #     @search = User.accessible_by(current_ability).ransack(params[:q])

    @search = User.includes(:institution).includes(:permission)
                  .accessible_by(current_ability).ransack(params[:q])

    @users = @search.result.page(params[:page]).per(10)
    @numusers = User.accessible_by(current_ability).count

    retrieve_users_without_contacts

    retrieve_nameless_contacts
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    # @user = User.find(params[:id])

    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    #       @cont=Contact.where(user_id: @user.id)

    @userold = @user # mantem a senha antiga

    respond_to do |format|
      if @user.update(user_params)

        #            sign_in @userold, :bypass=>true

        sign_in @user, bypass: true

        format.html do
          reset_session unless is_regular_user(current_user)

          redirect_to @user, notice: t('activerecord.models.user').titleize + \
                                     ' ' + t('updated.m') + ' ' + t('succesfully')
        end

        format.json { head :no_content }
      # Marcelo

      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      # Sign in the user by passing validation in case his password changed
      sign_in @user, bypass: true
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @contact = Contact.where(user_id: @user.id).first

    if @contact.nil?

      @user.destroy

      respond_to do |format|
        format.html { redirect_to users_path }

        format.json { head :no_content }
      end

      flash[:notice] = t('activerecord.models.user').titleize + ' ' + t('removed.m') + '.'

    else

      redirect_to @contact
      flash[:alert] = t('user_removal_lock')

    end
  end

  def show
    #  @user = User.find(params[:id])
    #  load_and_authorize did this automatically

    @title = if @user.id == current_user.id || is_regular_user(current_user)

               t('personal_info').mb_chars.upcase + ' | ' + tm('user').capitalize + \
                 ' | ' + t('actions.show')

             else

               t('people').pluralize.upcase + ' | ' + tm('user').pluralize.capitalize + \
                 ' | ' + t('actions.show')

             end

    unless @user.versions.last.nil? # it could have been seeded in which case we must test for nil

      @userid = @user.versions.last.whodunnit
      @userwho = User.where(id: @userid).first
    end
  end

  def edit
    @title = if @user.id == current_user.id || is_regular_user(current_user)

               t('personal_info').mb_chars.upcase + ' | ' + tm('user').capitalize \
                + ' | ' + t('actions.edit')

             else

               t('people').pluralize.upcase + ' | ' + tm('user').capitalize + ' | ' + t('actions.edit')

             end

    #   @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json

  def new
    @user = User.new
    @title = t('new.m').capitalize + ' ' + t('activerecord.models.user')

    if is_admin_or_manager(current_user)

      @title = t('people').pluralize.upcase + ' | ' + tm('user').pluralize.capitalize + ' | ' + t('actions.new.m')

    else

      @title = t('personal_info').mb_chars.upcase + ' | ' + tm('user').capitalize + ' | ' + t('actions.new.m')

    end
  end

  def create
    @user = User.new(user_params) # Not saving @user ...

    if is_local(current_user)
      @user.institution_id = current_user.institution_id
      @user.password = 'sample.17'
      @user.password_confirmation = 'sample.17'
    end

    if @user.save
      #       flash[:success] = "Usuário criado com sucesso.  Favor preencher as informações de contato pertinentes e confirmar."

      flash[:success] = t('activerecord.models.user') + ' ' + t('created.m') + ' ' + t('succesfully')

      presumed_contact_role_id = Role.clericalworker.first.id

      if (is_local_admin(current_user) || is_manager(current_user)) && @user.permission.regular?

        presumed_contact_role_id = Role.pap.student.first.id

      end

      @contact = Contact.new(user_id: @user.id, name: '', role_id: presumed_contact_role_id)

      # Nested attributes ---------
      @contact.build_address
      @contact.build_phone
      @contact.build_webinfo
      @contact.build_personalinfo
      # ---------------------------

      if @contact.save(validate: false)
        #       if @contact.save!

        redirect_to edit_contact_path(@contact)

      end

    # redirect_to users_path

    else
      flash[:error] = "N\xC3\xA3o foi poss\xC3\xADvel criar o usu\xC3\xA1rio.  Verifique os dados digitados e tente novamente."
      render :new
    end
  end
end

private
# Use callbacks to share common setup or constraints between actions.
def set_user
  @user = User.find(params[:id])
end

def retrieve_nameless_contacts
  # Added for 2017 - nameless
  @nameless_contacts = Contact.accessible_by(current_ability).nameless
  @num_nameless_contacts = @nameless_contacts.count
    end

def retrieve_users_without_contacts
  # Added for 2018 - without contact
  @users_without_contact = User.accessible_by(current_ability).without_contact
  @num_users_without_contact = @users_without_contact.count
    end

# Never trust parameters from the scary internet, only allow the white list through.
def user_params
  #   params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :institution_id, :pap, :paplocaladm, :papmgr, :medres, :medreslocaladm, :medresmgr, :admin, :adminreadonly, :papcollaborator, :medrescollaborator, :permission_id)
  params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :institution_id, :permission_id)
end

def ensure_admin
  unless
current_user&.admin?
    redirect_to :root

 end

  # Used for local admins
  def probable_role(user)
    roles = if user.permission.regular?

              Role.pap.student

            else

              Role.clerical

            end

    role = roles.pap.first if user.pap?

    role = roles.medres.first if user.medres?

    role
  end
end
