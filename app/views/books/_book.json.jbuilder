json.extract! book, :id, :name, :image, :price, :purchase_date, :user_id, :created_at, :updated_at
json.url book_url(book, format: :json)
