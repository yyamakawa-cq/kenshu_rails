class BooksController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate
  before_action :set_book, only: [:update]

  def index
    set_user
    @limit = params[:limit].to_i || 20
    @page = params[:page].to_i || 1
    offset = @limit * (@page - 1 )
    @count = Book.where(user_id: @user.id).count
    @pages = @count / @limit
    if @count % @limit != 0
      @pages += 1
    end
    @books = Book.where(user_id: @user.id).limit(@limit).offset(offset).order(id: :asc)
    @status = 200
  end

  def create
    set_user
    @book = Book.new(book_params)
    @book["user_id"] = @user.id
    if @book.save
      @status = 200
      render :show, status: :ok
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    set_user
    if @user.id != @book.user_id
      render json: { "status": 400, "message": "tokenのユーザーidと違う" }, status: :bad_request
    else
      if @book.update(book_params)
        @status = 200
        render :show, status: :ok
      else
        render json: @book.errors, status: :unprocessable_entity
      end
    end
  end

  protected
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      User.exists?(token: token)
    end
  end

  private
    def set_user
      authenticate_with_http_token do |token, options|
        @user = User.find_by(token: token)
      end
    end

    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:name, :image, :price, :purchase_date)
    end
end
