class UpdateParentUsersForReminders < ActiveRecord::Migration
  def change
    add_column \
      :users,
      :cell_phone,
      :string

    add_column \
      :users,
      :reminder_delivery_preference,
      :integer
  end
end
