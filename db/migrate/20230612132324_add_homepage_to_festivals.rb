class AddHomepageToFestivals < ActiveRecord::Migration[5.2]
  def change
    add_column :festivals, :homepage, :string
  end
end
