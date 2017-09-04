class BooksController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate
  before_action :set_user
  before_action :set_book, only: [:update]
  IMGUR_URL = 'https://api.imgur.com/3/image'.freeze
  CLIENT_ID = 'a732b09187a4d41'.freeze
  LIMIT = 20.freeze
  PAGE = 1.freeze
  @@token

  def index
    @limit = (params[:limit] || LIMIT).to_i
    @page = (params[:page] || PAGE).to_i
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
    @book = @user.books.build(book_params)
    @book.image = upload_image(params[:image])
    if @book.save
      @status = 200
      render :show, status: :ok
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.id != @book.user_id
      render json: { 'status': 400, 'message': 'tokenのユーザーidと違う' }, status: :bad_request
    else
      params[:book][:image] = upload_image(params[:image])
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
        @@token = token
      end
    end

  private
    def upload_image(image)
      header = {'Authorization' => 'Client-ID ' + CLIENT_ID}
      http_client = HTTPClient.new
      body = { 'image' => image }
      @res = http_client.post(URI.parse(IMGUR_URL), body, header)
      result_hash = JSON.load(@res.body)
      result_hash['data']['link']
    end

    def set_user
      @user = User.find_by(token: @@token)
    end

    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:name, :image, :price, :purchase_date)
    end
end
