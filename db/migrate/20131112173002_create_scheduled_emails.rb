class CreateScheduledEmails < ActiveRecord::Migration
  def change
    create_table :scheduled_emails do |t|
      t.references :parent, index: true
      t.references :kid, index: true
      t.boolean :delivered, :default => false
      t.string :image_id
      t.string :image_key
      t.string :caption

      t.timestamps
    end
  end
end
