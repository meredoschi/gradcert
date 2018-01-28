module TaxationsHelper
  
  def display_limit(bracket)

    if bracket.unlimited?
      
      res="---"
      
    else
       
      res=humanized_money(bracket.finish) 
  
    end
    
    return res.html_safe
    
  end

end
