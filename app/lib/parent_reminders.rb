class ParentReminders
  def self.send
    new.send!
  end

  def parent_ids_with_scheduled_email
    @_parent_ids_with_scheduled_email ||=
      ScheduledEmail.where(
        :delivered => false
      ).select(
        'DISTINCT parent_id'
      ).map &:parent_id
  end

  def parents_without_scheduled_email
    @_parents_without_scheduled_email ||=
      Parent.where \
        'id NOT IN (:parent_ids)',
        :parent_ids => parent_ids_with_scheduled_email
  end

  def send!
    parents_without_scheduled_email.each do | parent |
      result =
        begin
          parent.send_upload_reminder
        rescue
          false
        end
    end
  end
end
