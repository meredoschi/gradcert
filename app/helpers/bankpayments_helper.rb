module BankpaymentsHelper

	def insurance_report_for_student(registration)

		info=registration.student_name+' '
		info+=registration.student.contact.personalinfo.tin.to_s+' '
		info+=I18n.l(registration.student.contact.personalinfo.dob)+' '
		info+=registration.student.contact.personalinfo.sex.to_s
		
	end
	
	def statement_for_registration(r)

		statement=Statement.for_registration_on_bankpayment(r,@bankpayment)
				
	end
	
	def skipped_payments_exist?
	
		return @num_skip_payment>0

	end

	def adjustments_exist?
	
		return @num_adjustments>0

	end

	def assiduos_annotations_exist?
	
		return @num_present_annotations>0

	end

	def absent_annotations_exist?
	
		return @num_absent_annotations>0

	end
		
	def payrolls_exist_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' && Payroll.count>0 then return true 		
				  when permission_for(user)=='papmgr' && Payroll.pap.count>0 then return true 				
				  when permission_for(user)=='medresmgr' && Payroll.medres.count>0 then return true 				
	      else
					return false
			  end	 				
							
	end



	def registrations_exist_for_institution_on_programyear?(registrations, pyear)
	
			return (registrations.on_program_year(pyear).count)>0

	end

	def calculate_social_security_fee2(bankpayment,registration)
	
			gross=calculate_gross_payment_due(bankpayment,registration)
			
			return Taxes.social_security(bankpayment, gross)
	
	end
	
	def calculate_income_tax2(bankpayment,registration)
	
			gross=calculate_gross_payment_due(bankpayment,registration)
	
			social_security_fee=calculate_social_security_fee2(bankpayment,registration)
			
			income_tax_due=Taxes.personal_income(@brackets, gross, social_security_fee) # social security paid counts as a deduction
			
			return income_tax_due
	
	end
	
	def calculate_net_amount(bankpayment,registration)
	
			gross=calculate_gross_payment_due(bankpayment,registration)
	
			social_security_fee=calculate_social_security_fee2(bankpayment,registration)
			
			income_tax_due=Taxes.personal_income(@brackets, gross, social_security_fee) # social security paid counts as a deduction
  
		  net=(gross-social_security_fee-income_tax_due)
	  
	  return net
	  
	end		


	def calculate_gross_payment_due(bankpayment,registration)

			payment=set_payment_amount
			
			monthsize=days_for_month(bankpayment.payroll.monthworked)

			if registration.annotated?

			# 	print "Annotation detected"
			
				annotation=registration.annotation.first
				
				if annotation.usual? # i.e. no complement

						if annotation.assiduous?
					
						# No discount
											
						else
					
					    absence_penalty=((payment/monthsize)*annotation.absences)

		      		payment-=absence_penalty

				# 			print "Absences: "+annotation.absences.to_s
													
						end

						
				else

				
					if annotation.discount.present? # defensive programming - check for nil 
        
				 		payment-=annotation.discount
         
		      end
      
    		  if annotation.supplement.present?
        
  					 payment+=annotation.supplement
         
      		end

				end
					
					if annotation.skip?

					# 	puts "Skip payment!"
											
						payment=0
						
					end
							
			  				
				else
				
					# 	print "Not annotated"
						
				end
			
			return payment
							
	end  
  
	def set_payment_amount

		if @bankpayment.payroll.special?
		
			 payment=@bankpayment.payroll.amount

		else
		
	    payment=Scholarship.in_effect_for(@bankpayment.payroll).first.amount
  
  	end
	
		return payment
	
	end	
	
	def segmentA_control(registration)
		
		txt=Settings.segmentoA.controle.banco
		txt+=Settings.segmentoA.controle.lote
		txt+=Settings.segmentoA.controle.registro

# 		txt+=registration.student.bankaccount.num.to_s 
#		txt+=(registration.student.bankaccount.digit).to_s 
			
		return txt.html_safe
		
	end
	
	def annotated?(registration)
	
	  if Annotation.for_payroll(@bankpayment.payroll).for_registration(registration).count==1
	    
	    return true
	    
	  else
	    
	    return false
	    
	  end
    
	end

	def absence_value_for(registration)
	    
#	    annotation=Annotation.for_payroll(@bankpayment.payroll).for_registration(registration).first 
	
			annotation=registration.annotation.first
			
	    payment=set_payment_amount

			days_in_month=days_for_month(@bankpayment.payroll.monthworked)

    	if annotation.absences.present? && annotation.absences>0

    	      return (payment/days_in_month*annotation.absences)

			else
				
					return 0			
			
    	end

	end		

	
	def display_annotation_details(registration)
	    
	    annotation=Annotation.for_payroll(@bankpayment.payroll).for_registration(registration).first 
	
	    payment=set_payment_amount

			days_in_month=days_for_month(@bankpayment.payroll.monthworked)
  
	    txt=''

	    if annotation.confirmed.present? && annotation.confirmed
	      
	      txt+=tm('annotation').capitalize+' '+ta('annotation.confirmed').downcase+"."
	          
	    end

	    if annotation.supplement.present?
	      
	      txt+=' '+ta('annotation.supplement')+': '
	          
	      txt+=humanized_money(annotation.supplement)
	
	    end
	    	    
	    if annotation.discount.present?
	      
	      txt+=' '+ta('annotation.discount')+': '
	          
	      txt+=humanized_money(annotation.discount)
	
	    end

    	if annotation.absences.present? && annotation.absences>0

    	      txt+=' '+ta('annotation.absences')+': '

    	      txt+=annotation.absences.to_s
    	      
    	      txt+='/'+days_in_month.to_s
    	      
    	      txt+=' ('+humanized_money(payment/days_in_month*annotation.absences).to_s+') '

    	end

    	if annotation.comment.present? 

    	      txt+=' '+ta('annotation.comment')+': '

    	      txt+=annotation.comment

    	end

	    return txt

	end		

	def calculate_absence_penalty(registration)

    payment=set_payment_amount
 
		days_in_month=days_for_month(@bankpayment.payroll.monthworked)

#    annotation=Annotation.for_payroll(@bankpayment.payroll).for_registration(registration).first

		annotation=registration.annotation.first

# 		return -17
# 		return days_in_month

		if annotation.present?
		
	    return (payment/days_in_month*annotation.absences)

		else
		
			return 0
			
		end
		
  end

	def display_absence_penalty(registration)

    payment=set_payment_amount
 
		days_in_month=days_for_month(@bankpayment.payroll.monthworked)

    annotation=Annotation.for_payroll(@bankpayment.payroll).for_registration(registration).first

# 		return -17
# 		return days_in_month

    return (payment/days_in_month*annotation.absences).to_s.html_safe

  end
		
	def display_full_amount
		  
	  return @bankpayment.payroll.amount.to_s.html_safe
	  
	end		
  
  def display_gross_amount(registration)
		  
	  return gross_payment(registration).to_s.html_safe
	  
	end		

  def calculate_social_security_fee(registration)
		  
	  return Taxes.social_security(@bankpayment, gross_payment(registration))
	  
	end		

  def display_social_security_fee(registration)
		  
	  return Taxes.social_security(@bankpayment, gross_payment(registration)).to_s.html_safe
	  
	end		


  def display_income_tax(registration)
		  
	  return Taxes.personal_income(@brackets, gross_payment(registration), Taxes.social_security(@bankpayment, gross_payment(registration))).to_s.html_safe
	  
	end		
    
	def display_net_amount(registration)
	
		gross=gross_payment(registration)
		
		social_security=Taxes.social_security(@bankpayment, gross) 

		income_tax=Taxes.personal_income(@brackets, gross, social_security)
  
	  net=(gross-social_security-income_tax)
	  
	  return net
	  
	end		
	  
end
