class SetDefaultUserReminderPreference < ActiveRecord::Migration
  def change
    reversible do | dir |
      change_table :users do | t |
        dir.up do
          t.change \
            :reminder_delivery_preference,
            :integer,
            :default => 0
        end

        dir.down do
          t.change \
            :reminder_delivery_preference,
            :integer
        end
      end
    end
  end
end
