class TutorialsController < ApplicationController

before_filter :authenticate_user!

	def show

	# Associations
# 		@association_name_in_local_language=[] # Association name (i18n)
	@translated_attribs=[]


	@permissions=Permission.accessible_by(current_ability)
	@roles=Role.accessible_by(current_ability)

#	@personalinfo_idtypes=Personalinfo.pluck(:idtype).uniq.sort

	 @personalinfo_idtypes=Personalinfo.where.not(idtype: nil).pluck(:idtype).uniq.sort

	@pages = { "user" => 1, "contact" => 2, "personalinfo" => 3, "address" => 4, "phone" => 5, "webinfo" => 6, "student" => 7, "diploma" => 8,  "registration" => 9 }
	@num_pages=@pages.size


	render template: "tutorials/#{params[:page]}"


	end

end
