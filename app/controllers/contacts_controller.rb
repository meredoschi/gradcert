# frozen_string_literal: true

# Contains contact information (required of all system users)
class ContactsController < ApplicationController
  before_action :set_contact, only: %i[show edit update destroy]

  before_action :authenticate_user!

  # Marcelo - CanCan
  load_and_authorize_resource

  # GET /contacts
  # GET /contacts.json

  def index
    @title = if is_staff(current_user)

               t('people').upcase + ' | ' + tm('contact').mb_chars.pluralize.capitalize

             else

               t('personal_info').mb_chars.upcase + ' | ' + t('my.m').capitalize \
               + ' ' + tm('contact')

             end

    # https://github.com/ryanb/cancan/wiki/Fetching-Records

    @all_contacts = Contact.includes(user: :institution).includes(:role)

    @contacts_for_current_ability = @all_contacts.accessible_by(current_ability)

    @search = @contacts_for_current_ability.ransack(params[:q])

    @contacts = @search.result.page(params[:page]).per(10)
    @numcontacts = @contacts_for_current_ability.count

    # New for 2018 registration season
    @contacts_ready_to_become_students = @contacts_for_current_ability
                                         .ready_to_become_students

    # January 2020 convenience method, handles nil condition
    @num_contacts_ready_to_become_students = @contacts_for_current_ability
                                             .num_ready_to_become_students

    retrieve_nameless_contacts
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @title = if @contact.user.id == current_user.id || is_regular_user(current_user)

               t('personal_info').mb_chars.upcase + ' | ' + t('my.m').capitalize \
               + ' ' + tm('contact') + ' | ' + t('actions.show')

             else

               t('people').pluralize.upcase + ' | ' + tm('contact').capitalize \
               + ' | ' + t('actions.show')

             end

    # it could have been seeded in which case we must test for nil
    (return if @contact.versions.last.nil?)

    @userid = @contact.versions.last.whodunnit
    @userwho = User.where(id: @userid).first
  end

  # GET /contacts/new
  def new
    # See users controller! (Create action)
    @title = t('people').pluralize.upcase + ' | ' + t('new.m') + ' ' \
     + t('activerecord.models.contact')
    @contact = Contact.new
    # Nested attributes ---------
    @contact.build_personalinfo
    @contact.build_address
    @contact.build_phone
    @contact.build_webinfo
    # ---------------------------
  end

  # GET /contacts/1/edit
  def edit
    # Nested attributes -----------------
    @contact = Contact.find(params[:id])
    # -----------------------------------

    @title = if @contact.user == current_user || is_regular_user(current_user)

               t('personal_info').mb_chars.upcase + ' | ' + t('my.m').capitalize \
                + ' ' + tm('contact') + ' | ' + t('actions.edit')

             else

               t('people').pluralize.upcase + ' | ' + tm('contact').capitalize \
               + ' | ' + t('actions.edit')

             end

    # @municipalities_ordered_by_state=Municipality.includes(stateregion: :state)
    # .ordered_by_asciiname_and_state
    # Alphabetical by state name without regard for accents

    # Much faster, since already saved to the database.
    # Ran:
    # rake fixes:municipalities_with_state
    # To do: enhance municipality controller in order to update this dynamically

    @municipalities_ordered_by_state = Municipality.order(:asciinamewithstate)

    @role = @contact.role
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html do
          redirect_to @contact, notice: t('activerecord.models.contact') \
          + ' ' + t('created.m') + ' ' + t('succesfully')
        end
        format.json { render action: 'show', status: :created, location: @contact }
      else
        format.html { render action: 'new' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    @municipalities_ordered_by_state = Municipality.order(:asciinamewithstate)

    respond_to do |format|
      if @contact.update(contact_params)
        format.html do
          redirect_to @contact, notice: t('activerecord.models.contact').titleize \
           + ' ' + t('updated.m') + ' ' + t('succesfully')
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    #   @user=User.find(params[@contact.user_id])

    if @contact.student.present?
      flash[:alert] = t('contact_removal_lock.student')
      redirect_to contacts_url
    else

      @contact.destroy
      respond_to do |format|
        format.html { redirect_to contacts_url }
        format.json { head :no_content }
      end
    end
  end

  # ---------------

  def retrieve_nameless_contacts
    # Added for 2017 - nameless
    @nameless_contacts = Contact.accessible_by(current_ability).nameless
    @num_nameless_contacts = @nameless_contacts.count
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:user_id, :name, :personalinfo_id, :email, :role_id,
                                    :address_id, :termstart, :termfinish, :taxpayercode, :image,
                                    :remove_image, :image_cache, :remote_image_url,
                                    address_attributes: %i[id municipality_id streetname_id \
                                                           country_id postalcode addr complement \
                                                           streetnum neighborhood
                                                           institution_id contact_id],
                                    phone_attributes: %i[id main other mobile contact_id \
                                                         institution_id],
                                    webinfo_attributes: %i[id site email facebook twitter other],
                                    personalinfo_attributes: %i[id mothersname municipality_id \
                                                                othername sex gender dob idtype \
                                                                idnumber state_id country_id \
                                                                socialsecuritynumber tin \
                                                                contact_id municipality_id])
  end
end
