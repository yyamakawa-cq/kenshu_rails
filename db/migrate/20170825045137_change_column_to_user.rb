class ChangeColumnToUser < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :email, :string, null:false
    change_column :users, :password, :string, null:false
    change_column :users, :token, :string, null:false
  end
  def down
    change_column :users, :email, :string, null:true
    change_column :users, :password, :string, null:true
    change_column :users, :token, :string, null:true
  end
end
