class WelcomeController < ApplicationController
  # http://stackoverflow.com/questions/5825135/devise-sign-up-page-as-welcome-landing-page-then-to-user-profile
  before_filter :authenticate_user!

  #   load_and_authorize_resource  # CanCan(Can)

  def index
    @title = I18n.t('greetings')

    @all_payrolls = if is_admin_or_manager(current_user)

                      Payroll.accessible_by(current_ability).includes(:taxation)

                    else

                      Payroll.accessible_by(current_ability)

                    end
    #

    @num_payrolls = @all_payrolls.count

    @latest_payroll = (@all_payrolls.latest.first if @num_payrolls > 0)
  end
end
