class UsersController < ApplicationController
  before_filter :correct_user, only: [:show, :edit, :update, :destroy]
  before_filter :signed_in_user, only: [:edit, :update]


  def index
    @users = User.search(params[:search]).paginate(page: params[:page], per_page: 9)
  end


  def show
     @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    # @user.date = Time.now
      if @user.save
        sign_in @user
        # flash[:success] = "Welcome to the language Q&A!"
        redirect_to @user
      else
        render 'new'
      end
    
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def user_params
    params.require(:user).permit(:email, :dispname, :name,:firstname,:lastname, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
end
