class ApplicationController < ActionController::Base
  protect_from_forgery
 helper_method :current_operator  
   
 private  
 def current_operator_session  
   return @current_operator_session if defined?(@current_operator_session)  
   @current_operator_session = OperatorSession.find  
 end  
   
 def current_operator
   @current_operator = current_operator_session && current_operator_session.record  
 end 
end
