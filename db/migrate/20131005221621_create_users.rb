class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.date :birthdate
      t.string :sex

      t.timestamps
    end
  end
end
