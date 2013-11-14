class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.references :user, index: true
      t.string :type
      t.string :number

      t.timestamps
    end
  end
end
