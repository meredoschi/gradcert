module ApplicationnavigationHelper
  # http://stackoverflow.com/questions/12361631/rendering-partials-from-a-helper-method

  def navigation_bar(user)
    if is_logged_in(user)

      profile = if permission_for(user) == 'admin' then render partial: 'layouts/navbar/system_administrator'
                elsif permission_for(user) == 'adminreadonly' then render partial: 'layouts/navbar/readonly'
                elsif permission_for(user) == 'pap' then render partial: 'layouts/navbar/regular_user'
                elsif permission_for(user) == 'papcollaborator' then render partial: 'layouts/navbar/collaborator'
                elsif permission_for(user) == 'paplocaladm' then render partial: 'layouts/navbar/local_administrator'
                elsif permission_for(user) == 'papmgr' then render partial: 'layouts/navbar/manager'
                elsif permission_for(user) == 'medres' then render partial: 'layouts/navbar/regular_user'
                elsif permission_for(user) == 'medrescollaborator' then render partial: 'layouts/navbar/collaborator'
                elsif permission_for(user) == 'medreslocaladm' then render partial: 'layouts/navbar/local_administrator'
                elsif permission_for(user) == 'medresmgr' then render partial: 'layouts/navbar/manager'

                #	 		when user.adminreadonly? then "adminreadonly"
                else render partial: 'layouts/navbar/common/help'
     end
   end
  end

  # http://stackoverflow.com/questions/12361631/rendering-partials-from-a-helper-method

  def reports_bar(user)
    if is_logged_in(user)

      profile = if permission_for(user) == 'admin' then render partial: 'layouts/reportsbar/system_administrator'
                elsif permission_for(user) == 'adminreadonly' then render partial: 'layouts/reportsbar/readonly'
                elsif permission_for(user) == 'pap' then render partial: 'layouts/reportsbar/regular_user'
                elsif permission_for(user) == 'papcollaborator' then render partial: 'layouts/reportsbar/collaborator'
                elsif permission_for(user) == 'paplocaladm' then render partial: 'layouts/reportsbar/local_administrator'
                elsif permission_for(user) == 'papmgr' then render partial: 'layouts/reportsbar/manager'
                elsif permission_for(user) == 'medres' then render partial: 'layouts/reportsbar/regular_user'
                elsif permission_for(user) == 'medrescollaborator' then render partial: 'layouts/reportsbar/collaborator'
                elsif permission_for(user) == 'medreslocaladm' then render partial: 'layouts/reportsbar/local_administrator'
                elsif permission_for(user) == 'medresmgr' then render partial: 'layouts/reportsbar/manager'

                #	 		when user.adminreadonly? then "adminreadonly"
                else render partial: 'layouts/reportsbar/common/help'
     end
   end
  end

  def nav_link(text, path)
    options = current_page?(path) ? { class: 'active' } : {}
    content_tag(:li, options) do
      link_to text, path
    end
end
end
