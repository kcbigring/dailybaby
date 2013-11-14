class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.references :user, index: true
      t.integer :delivery_id

      t.timestamps
    end
  end
end
