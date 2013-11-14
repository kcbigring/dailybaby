class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.references :user, index: true
      t.integer :kid_id

      t.timestamps
    end
  end
end
