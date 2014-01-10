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

  def parents_without_scheduled_email
    return @_parents_without_scheduled_email if @_parents_without_scheduled_email.present?

    query_args =
      if !parent_ids_with_scheduled_email.empty?
        [
          'id NOT IN (:parent_ids)',
          :parent_ids => parent_ids_with_scheduled_email
        ]
      else
        [ 'id NOT IN ()' ]
      end

    @_parents_without_scheduled_email ||= Parent.where *query_args
  end

  def deliver!
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
