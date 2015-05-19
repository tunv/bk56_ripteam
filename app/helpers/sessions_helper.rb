module SessionsHelper

  def sign_in(user)
    session[:user_id] = user.id
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

 def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])

      user = User.find_by(id: user_id)
        if user && user.authenticated?(:remember, cookies[:remember_token])
        sign_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    self.current_user = nil
    session.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # check and redirect

  def signed_in_user
    redirect_to signin_path unless signed_in?
  end

end
