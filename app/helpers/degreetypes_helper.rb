module DegreetypesHelper

  # To do: future implementation!
  
  # Includes local admins (i.e. Degreetypes for users from own institution)
   def available_types_for(user)

       profile = case

       when Degreetype_for(user)=='admin' then return Degreetype.all
       when Degreetype_for(user)=='papmgr' then return Degreetype.all
  #     when Degreetype_for(user)=='medresmgr' then return Degreetype.all
#       when Degreetype_for(user)=='medreslocaladm' then return Degreetype.all
       when Degreetype_for(user)=='paplocaladm' then return Degreetype.paplocal

       end
   end

end
