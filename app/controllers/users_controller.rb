class UsersController < ApplicationController

  def create
    @user = User.new(user_params)

    if @user.save
      @status = 200
      render :show, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :token)
    end
end
