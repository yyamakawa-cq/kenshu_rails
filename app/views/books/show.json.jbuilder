#json.partial! "books/book", book: @book
json.status @status
json.result do
  json.extract! @book, :id, :name, :image, :price, :purchase_date
end
