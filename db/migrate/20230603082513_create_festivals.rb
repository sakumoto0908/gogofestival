class CreateFestivals < ActiveRecord::Migration[5.2]
  def change
    create_table :festivals do |t|
      t.text :event
      t.text :place
      t.text :ditail

      t.timestamps
    end
  end
end
