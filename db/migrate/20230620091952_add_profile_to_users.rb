class AddProfileToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :gender, :string
    add_column :users, :address, :string
    add_column :users, :self_introduction, :text
    
  end
end
