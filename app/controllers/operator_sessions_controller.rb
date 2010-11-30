class OperatorSessionsController < ApplicationController

  def new
		@operator_session = OperatorSession.new
  end

 def create  
   @operator_session = OperatorSession.new(params[:operator_session])  
   if @operator_session.save  
     flash[:notice] = t('login.message.success')
     redirect_to :controller => :welcome, :action => :index
   else  
      #render :action => 'new'  
      flash[:warning] = t('login.message.failed')
      redirect_to :controller => :welcome, :action => :index
   end  
 end 

 def destroy  
   @operator_session = OperatorSession.find  
   @operator_session.destroy  
   flash[:notice] = t('login.message.logout')
   redirect_to root_url  
 end

end
