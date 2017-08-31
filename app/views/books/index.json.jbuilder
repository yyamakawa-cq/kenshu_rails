json.status @status
json.result do
  json.array! @books, :id, :name, :image, :price, :purchase_date
end
json.total_count @count
json.total_pages @pages
json.current_page @page
json.limit @limit
