class SessionsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

  def create
    if !(User.exists?(email: params[:email].downcase))
      @status = 404
      @message = "該当メールアドレスなし"
      render "users/error", status: :not_found
    else
      @user = User.find_by!(email: params[:email].downcase)
      if @user.password != params[:password] then
        @status = 401
        @message = "パスワードが不正"
        render "users/error", status: :unauthorized
      elsif @user.password == params[:password] then
        if @user.token != request.headers[:authorization]
          @user.regenerate_token
          @status = 200
          render "users/show", status: :ok
        else @user.token == request.headers[:authorization]
          @status = 200
          render "users/show", status: :ok
        end
      end
    end
  end

  def destroy
    render json: { "status": 200 }, status: :ok
  end

  protected
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      User.exists?(token: token)
    end
  end
end
