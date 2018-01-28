class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user!

  # Marcelo - CanCan
	load_and_authorize_resource

  # GET /contacts
  # GET /contacts.json

  def index

	 	if is_staff(current_user)

			@title=t('people').upcase+' | '+tm('contact').mb_chars.pluralize.capitalize

    else

				@title=t('personal_info').mb_chars.upcase+' | '+t('my.m').capitalize+" "+tm('contact')

		end

		# https://github.com/ryanb/cancan/wiki/Fetching-Records

 		@all_contacts=Contact.includes(user: :institution).includes(:role)

		@contacts_for_current_ability=@all_contacts.accessible_by(current_ability)

  	@search = @contacts_for_current_ability.ransack(params[:q])

  	@contacts=@search.result.page(params[:page]).per(10)
		@numcontacts=@contacts_for_current_ability.count

    retrieve_nameless_contacts

  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show

		if @contact.user.id==current_user.id || is_regular_user(current_user)

			@title=t('personal_info').mb_chars.upcase+' | '+t('my.m').capitalize+" "+tm('contact')+' | '+t('actions.show')

		else

	   	 @title=t('people').pluralize.upcase+' | '+tm('contact').capitalize+' | '+t('actions.show')

		end

		if !@contact.versions.last.nil?  # it could have been seeded in which case we must test for nil

	 		@userid=@contact.versions.last.whodunnit
	 		@userwho=User.where(id: @userid).first

		end


  end

  # GET /contacts/new
  def new
    # See users controller! (Create action)
  	@title=t('people').pluralize.upcase+' | '+t('new.m')+' '+t('activerecord.models.contact')
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

		if @contact.user==current_user || is_regular_user(current_user)

			@title=t('personal_info').mb_chars.upcase+' | '+t('my.m').capitalize+" "+tm('contact')+' | '+t('actions.edit')

		else

	   	 @title=t('people').pluralize.upcase+' | '+tm('contact').capitalize+' | '+t('actions.edit')


		end

# 	@municipalities_ordered_by_state=Municipality.includes(stateregion: :state).ordered_by_asciiname_and_state # Alphabetical by state name without regard for accents

# Much faster, since already saved to the database.
# Ran:
# rake fixes:municipalities_with_state
# To do: enhance municipality controller in order to updated this dynamically

	@municipalities_ordered_by_state=Municipality.order(:asciinamewithstate)

  @role=@contact.role

  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: t('activerecord.models.contact')+' '+t('created.m')+' '+t('succesfully') }
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

    @municipalities_ordered_by_state=Municipality.order(:asciinamewithstate)

    respond_to do |format|

    if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: t('activerecord.models.contact').titleize+' '+t('updated.m')+' '+t('succesfully') }
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

   # 	@user=User.find(params[@contact.user_id])

  	case
   		when @contact.student.present?
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

# -------------------------

  def retrieve_nameless_contacts

  # Added for 2017 - nameless
  @nameless_contacts=Contact.accessible_by(current_ability).nameless
  @num_nameless_contacts=@nameless_contacts.count

  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
	 		params.require(:contact).permit(:user_id, :name, :personalinfo_id, :email, :role_id, :address_id, :termstart, :termfinish, :taxpayercode, :image, :remove_image,  :image_cache, :remote_image_url, address_attributes: [:id, :municipality_id, :streetname_id, :country_id, :postalcode, :addr, :complement, :streetnum, :neighborhood, :institution_id, :contact_id], phone_attributes: [:id, :main, :other, :mobile, :contact_id, :institution_id], webinfo_attributes: [:id, :site, :email, :facebook, :twitter, :other], personalinfo_attributes: [:id, :mothersname, :municipality_id, :othername, :sex, :gender, :dob, :idtype, :idnumber, :state_id, :country_id, :socialsecuritynumber, :tin, :contact_id, :municipality_id])
 #  		params.require(:contact).permit!
    end
end
