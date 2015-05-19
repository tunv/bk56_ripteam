class SessionsController < ApplicationController
   def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      flash[:success] = "Welcome to the language Q&A!"
      sign_in @user
      redirect_to @user
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end
 
  def destroy
    sign_out
    redirect_to root_path
  end
  
end
