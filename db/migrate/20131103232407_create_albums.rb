class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :smugmug_id
      t.string :key
      t.string :nice_name
      t.string :title
      t.string :url
      t.integer :kid_id
      t.string :password
      t.string :custom_url

      t.timestamps
    end
  end
end
