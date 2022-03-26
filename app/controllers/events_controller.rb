class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

  # GET /events
  def index

# @search.sorts = ['name asc', 'created_at desc'] if @search.sorts.empty?

		@title=t('list')+' '+t('activerecord.models.event').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('navbar.studentregistration').mb_chars.pluralize.upcase
      @title+=' | '+t('activerecord.models.event').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('navbar.studentregistration').mb_chars.pluralize.upcase
        @title+=' | '+t('activerecord.models.event').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('event').pluralize.upcase

  		end

    end

    @all_users=User.all
    @all_events=Event.includes(:registration).includes(:leavetype).includes(registration: {student: [contact: :personalinfo]})

    @all_institutions=Institution.all

  	@search = @all_events.ordered_by_contact_name.accessible_by(current_ability).ransack(params[:q])
  # 	@search.sorts = 'contacts.name asc' if @search.sorts.empty?
#   	@events=@search.result.chronologically.page(params[:page]).per(50)

    @events_without_pagination=@search.result.chronologically

    if is_admin_or_manager(current_user)

      items_per_page=10

    else

      items_per_page=20

    end

      @events=@events_without_pagination.page(params[:page]).per(items_per_page)

    @all_registrations=Registration.all

#     @all_registrations=Registration.includes(student: [contact: :personalinfo])

		@ids_with_events=@all_registrations.ids_with_events

		@registrations_with_events=@all_registrations.includes(student: [contact: :personalinfo]).accessible_by(current_ability).where(id: @ids_with_events).ordered_by_contact_name # 1 or more events

		@num_events=@all_events.accessible_by(current_ability).count

		@institutions_with_events=@all_institutions.accessible_by(current_ability).where(id: @all_events.institution_ids)

    # Copied from events
    respond_to do |format|
      format.html
      format.pdf do
    #		export_results_to_pdf
        events_report
      end
    end


  end

  # GET /events/1
  def show
  	@title=t('activerecord.models.event').capitalize

#  	if !@event.name.nil?

#    	@title=@title+": "+@event.name

#     end

  	if is_admin_or_manager(current_user)

			@title=t('navbar.studentregistration').mb_chars.pluralize.upcase+" | "+t('activerecord.models.event').capitalize+": "+@event.name

    else

 	 		if is_local_admin(current_user)

				@title=t('navbar.studentregistration').mb_chars.mb_chars.upcase+' | '+t('activerecord.models.event').capitalize

			else

				@title=tm('event').pluralize.upcase

				if !@event.name.nil?

					@title+=" : "+@event.name

				end

			end

		end

		check_log

  end

  # GET /events/new
  def new
    @event = Event.new

    set_registrations

    if is_admin_or_manager(current_user)

			@title=t('navbar.studentregistration').mb_chars.pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.event')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.event')

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.event')

			end

		end

  end

  # GET /events/1/edit
  def edit

    set_registrations

#     @title=t('noun.edit')+" "+t('activerecord.models.event')

    if is_admin_or_manager(current_user)

				@title=t('navbar.studentregistration').mb_chars.pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.event')

    	else

			if is_local_admin(current_user)

				@title=t('navbar.studentregistration').mb_chars.pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.event')

			else

 			  @title=t('noun.edit')+' '+tm('event').pluralize

			end

  	end


  end

  # POST /events
  def create

    @event = Event.new(event_params)

		set_number_of_days
		set_confirmation_status
    set_registrations

		@num_active_registrations=calculate_num_active_registrations


    if @event.save
      redirect_to @event, notice: t('activerecord.models.event').capitalize+' '+t('created.m')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update

	  set_number_of_days
    set_registrations

    if @event.update(event_params)
     # redirect_to @event, notice: 'Event was successfully updated.'
       redirect_to @event, notice: t('activerecord.models.event').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: t('activerecord.models.event').capitalize+' '+t('deleted.m')+' '+t('succesfully')

  end

  private

  # Statement report pagination
	def paginate_events(pdf, i)

		if (i%4==0)

			pdf.start_new_page


		else

			pdf.text " "
			pdf.stroke_horizontal_rule
			pdf.text " "

		end

	end

	def cover_page_single(pdf)

      pdf.pad(20) { pdf.text "#{Settings.fullname.pap}", :align => :center, :size => 20  }

			pdf.pad(18) { pdf.text "Relatório de conferência de movimentos", :align => :center, :size => 18  }

			registration=@filtered_registrations.first # get institution

			pdf.pad(10) { pdf.text registration.institution, :align => :center, :size => 18  }


			pdf.line_width = 2

			pdf.pad(10) { pdf.text registration.report_details, :align => :center, :size => 16  }

			pdf.fill_color "553311"

			pdf.move_down 120

			pdf.stroke_horizontal_rule

			pdf.pad(5) {   pdf.text "#{current_user.contact.name} - #{current_user.email} - #{current_user.contact.role.name}", :align => :center, :size => 14 }
			pdf.pad(5) {   pdf.text "#{I18n.l(Time.now).capitalize} ", :align => :center, :size => 14 }

			pdf.stroke_horizontal_rule

			pdf.fill_color "000000"


	end

	# Write PDF cover page (for multiple registrations)
	def cover_page(pdf)

			pdf.canvas do
				pdf.fill_circle [pdf.bounds.left, pdf.bounds.top], 30
				pdf.fill_circle [pdf.bounds.right, pdf.bounds.top], 30
				pdf.fill_circle [pdf.bounds.right, pdf.bounds.bottom], 30
				pdf.fill_circle [0,0], 30

			end


      pdf.pad(20) { pdf.text "#{Settings.fullname.pap}", :align => :center, :size => 20  }

      pdf.pad(18) { pdf.text "Relatório de conferência de movimentos", :align => :center, :size => 16  }

			if @num_filtered_institutions > 1

				pdf.pad(10) { pdf.text ActionController::Base.helpers.pluralize(@num_filtered_institutions, I18n.t('activerecord.models.institution').capitalize) }

			end

			pdf.stroke_horizontal_rule


			pdf.pad(10) { pdf.text ActionController::Base.helpers.pluralize(@num_filtered_registrations, I18n.t('activerecord.models.registration').capitalize) }

			pdf.pad(10) { pdf.text ActionController::Base.helpers.pluralize(@num_filtered_events, I18n.t('activerecord.models.event').capitalize) }

			pdf.stroke_horizontal_rule

			pdf.pad(10) { pdf.text "#{I18n.l(Time.now).capitalize} ", :align => :center, :size => 12 }

			pdf.stroke_horizontal_rule

			pdf.start_new_page

	end

	# Set page numbering options
	def page_numbering(pdf)

#			string = "página"+" "+"<page>"+" / "+"<total>"

			string = I18n.t('page').capitalize+" <page> "+I18n.t('of.n')+" <total>"

			options = { :at => [pdf.bounds.right - 200, 0],
			:width => 200,
			:size => 10,
			:align => :right,
			:color => "3a7069",
			:start_count_at => 2 }

			options[:page_filter] = lambda{ |pg| pg > 1 }
 			pdf.number_pages string, options

			left_options = { :at => [0, pdf.bounds.left],
			:width => 400,
			:size => 10,
			:align => :left,
			:start_count_at => 2 }

			now=I18n.l(Time.now, format: :compact)
# 			tin_label=I18n.t('activerecord.attributes.personalinfo.tin') # CPF (Brazil)

# 			txt="#{current_user.contact.name} (#{tin_label}: #{current_user.contact.personalinfo.tin}) - "+now

			txt="#{current_user.contact.name} - ID: #{current_user.id} - "+now

  		pdf.number_pages txt, left_options

=begin

			odd_options = { :at => [pdf.bounds.right - 200, 0],
			:width => 200,
			:align => :right,
			:page_filter => :odd,
			:start_count_at => 1 }




 			pdf.number_pages string, odd_options

			pdf.number_pages string, even_options

=end

	end

  # Local admin method - in progress
  def output_events(report)


        @filtered_events.each_with_index do |event, i|

          paginate_events(report, i)

          write_to(report, event)

        end

  end

	# Layout is different if a specific registration is chosen
	def output_events_for_a_single_registration(report)

			@filtered_events.each_with_index do |event, i|

				paginate_events(report, i)

				write_to(report, event)

			end

	end

  # Generate event information as pdf
	def write_to(pdf, event)

			registration=event.registration
			student=registration.student
			personalinfo=student.contact.personalinfo

      pdf.text " "

      if event.confirmed?

        pdf.text "***** Movimento autorizado ******* "

      else

        pdf.text "!!!!! Movimento pendente !!!!! "

      end

      pdf.text "ID:  #{event.id.to_s} "


  		pdf.text "Bolsista: #{registration.full_details}"
      pdf.text ""
      pdf.text "Horário de criação:  #{I18n.l(event.created_at, format: :compact)}"

      pdf.text "Período informado: #{I18n.l(event.start)} a #{I18n.l(event.finish)}"

      if event.leave?

        pdf.text "Licença: "+event.leavetype.name

      else

        pdf.text "Faltas"

      end

      if event.residual?

         pdf.text "Gerado automaticamente pelo sistema, referente a situação de matrícula"

      end

      pdf.text "Número de dias: #{(event.numdays)} "

      pdf.text ""
      pdf.text ""
	end

	# Process statements for multiple registrations, sorted by bankpayment and institution.
	def output_events_from_multiple_registrations(report)

			report.line_width = 3

			report.stroke_horizontal_rule

# 			@filtered_bankpayments.each do |bankpayment|

				if current_user.pap?

					report.pad(20) { report.text "#{Settings.fullname.pap}", :align => :center, :size => 20  }

				else

					if current_user.medres?

						report.pad(20) { report.text "#{Settings.fullname.medres}", :align => :center, :size => 20  }

					end

# 				end

				report.pad(20) { report.text "#{I18n.t('activerecord.models.event')}", :align => :center, :size => 16  }

				@filtered_institutions.each do |institution|

					report.pad(20) { report.text institution.name, :align => :center, :size => 18  }

					report.stroke_horizontal_rule

  				report.pad(20) { report.text "#{current_user.contact.name} - #{current_user.email} - #{current_user.contact.role.name}", :align => :center, :size => 14  }

						@filtered_events.from_institution(institution).each_with_index do |event, i|

							paginate_events(report, i)

							write_to(report, event)

						end

					report.stroke_horizontal_rule

					report.start_new_page

				end

			end

	end

  # Export results to a report on PDF
  def events_report

      # Filtered results

      @filtered_events=@events_without_pagination # Alias

      @filtered_registration_ids=@events_without_pagination.pluck(:registration_id).uniq
      @filtered_registrations=@all_registrations.where(id: @filtered_registration_ids)

      @filtered_institution_ids=@events_without_pagination.institution_ids

      @filtered_institutions=@all_institutions.where(id: @filtered_institution_ids).ordered_by_name

      @num_filtered_events=@filtered_events.count
      @num_filtered_registrations=@filtered_registrations.count
      @num_filtered_institutions=@filtered_institutions.count

      pdf = Prawn::Document.new

      if @num_filtered_registrations > 1

        cover_page(pdf)

#         output_events_from_multiple_registrations(pdf)


      else

        cover_page_single(pdf)

  #       output_events_for_a_single_registration(pdf)

      end


      output_events(pdf)

      page_numbering(pdf) # Called *after* the contents are created


      fname=I18n.t('activerecord.models.event').capitalize.pluralize+'_'+Pretty.right_now+'.pdf'


      send_data pdf.render, filename: fname, type: 'application/pdf'

  end



    # Verify if record was edited
    def check_log

  	  if !@event.versions.last.nil?  # it could have been seeded in which case we must test for nil

  	 			@userid=@event.versions.last.whodunnit

  	 			if !@userid.nil?

  					@user=User.where(id: @userid).first

  				else @user=nil

  				end

  		end

   end

   def calculate_num_active_registrations

			records = case

#	        when permission_for(user)=='admin' then Registration.active.joins(student: :contact).order("contacts.name")
#	        when permission_for(user)=='papmgr' then Registration.pap.active.joins(student: :contact).order("contacts.name")
#	        when permission_for(user)=='paplocaladm' then Registration.pap.active.ordered_by_contact_name.from_own_institution(user)

	        when permission_for(current_user)=='admin' then return Registration.active.joins(student: :contact).count
	        when permission_for(current_user)=='papmgr' then return Registration.pap.active.joins(student: :contact).count
	        when permission_for(current_user)=='paplocaladm' then return Registration.pap.active.from_own_institution(current_user).count

				end

   end

  	# Set days since application's Epoch
    def set_number_of_days

      if @event.start.present? && @event.finish.present?

			  @event.daystarted=@event.startday
			  @event.dayfinished=@event.finishday

			else

			  @event.daystarted=Settings.operational_start # Defensive programming
			  @event.dayfinished=Settings.operational_start

      end

		end

    #

    # Used by the helper method: registrations_for(user)
    def set_registrations

      latest_payroll_start_date=Payroll.accessible_by(current_ability).actual.regular.latest.first.start

#      @all_registrations=Registration.accessible_by(current_ability).includes(student: [contact: :personalinfo])

#      @all_registrations=Registration.accessible_by(current_ability).contextual_on(latest_payroll_start_date).includes(student: [contact: :personalinfo])

#      if is_pap_manager(current_user)
#        @all_registrations=Registration.all.includes(student: [contact: :personalinfo])

        @all_registrations=Registration.all
        @contextual_registrations=@all_registrations.accessible_by(current_ability).contextual_on(latest_payroll_start_date).includes(student: [contact: :personalinfo]).order("contacts.name")
        @active_registrations=@contextual_registrations.active
#      else
#        @all_registrations=Registration.accessible_by(current_ability).contextual_on(latest_payroll_start_date).includes(student: [contact: :personalinfo])
#      end

    end
		# According to role and event type
    def set_confirmation_status

      if is_local_admin(current_user)

          @event.confirmed=false

      else

      		@event.confirmed=true # i.e. Admin or manager

      end

		end

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:start, :finish, :leavetype_id, :absence, :registration_id, :residual, :confirmed, :processed, :supportingdocumentation, :remove_supportingdocumentation,  :supportingdocumentation_cache, :remote_supportingdocumentation_url)
    end
end
