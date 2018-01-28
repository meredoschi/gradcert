class RemindToLogin < ApplicationMailer
# http://stackoverflow.com/questions/13302414/rails-mailer-instance-variable-nil-in-email-view

	default from: 'noreply@example.com'

    def notification(user)
      @user = user
      mail(:bcc => @user.email, subject: 'Gradcert - System message')
    end

	def notify_pap_local_admin(user_id)
	    @user = User.find_by_id user_id

	    if (@user)
	      to = @user.email

	      mail(:to => to, :subject => 'Gradcert - System message') do |format|
	        format.text(:content_type => "text/plain", :charset => "UTF-8", :content_transfer_encoding => "7bit")
	      end
	    end
	end

end
