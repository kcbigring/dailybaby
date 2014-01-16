class ParentReminders
  def self.deliver
    new.deliver!
  end

  def parent_ids_with_scheduled_email
    @_parent_ids_with_scheduled_email ||=
      ScheduledEmail.where(
        :delivered => false
      ).select(
        'DISTINCT parent_id'
      ).map &:parent_id
  end

  def parents_who_prefer_reminders
    Parent.where \
      'reminder_delivery_preference IN ( :active_preferences )',
      :active_preferences => Parent::REMINDER_DELIVERY_PREFERENCES.values
  end

  def parents_without_scheduled_email
    @_parents_without_scheduled_email ||=
      if parent_ids_with_scheduled_email.any?
        parents_who_prefer_reminders.where \
          'id NOT IN ( :parent_ids )',
          :parent_ids => parent_ids_with_scheduled_email
      else
        parents_who_prefer_reminders
      end
  end

  def deliver!
    parents_without_scheduled_email.each do | parent |
      begin
        parent.send_upload_reminder
      rescue
        false
      end
    end
  end
end
