class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null:false
      t.string :password, null:false
      t.string :token, null:false

      t.timestamps
    end
    add_index :users, :token, unique: true
    add_index :users, :email, unique:true
  end
end
