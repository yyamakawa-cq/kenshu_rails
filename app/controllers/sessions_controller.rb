class SessionsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate, only: [:create]

  def create
    if !(User.exists?(email: params[:email].downcase))
      render json: { 'status': 404, 'message': '該当メールアドレスなし' }, status: :not_found
    else
      @user = User.find_by!(email: params[:email].downcase)
      if @user.password != params[:password] then
        render json: { 'status': 401, 'message': 'パスワードが不正' }, status: :unauthorized
      elsif @user.password == params[:password] then
        authenticate_with_http_token do |token, options|
          if @user.token != token
            @user.regenerate_token
          end
        end
        @status = 200
        render 'users/show', status: :ok
      end
    end
  end

  def destroy
    render json: { 'status': 200 }, status: :ok
  end

  protected
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      User.where('(token = ?) OR (email = ?)', token, params[:email].downcase)
    end
  end
end
