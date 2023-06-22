class CreateGones < ActiveRecord::Migration[5.2]
  def change
    create_table :gones do |t|
      t.integer :user_id
      t.integer :festival_id

      t.timestamps
    end
  end
end
