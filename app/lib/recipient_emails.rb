class RecipientEmails
  def self.deliver
    new.deliver!
  end

  def emails
    ScheduledEmail.where :delivered => false
  end

  def image_data_for( email )
    smug_mug_image_for( email ).mediumurl
  rescue
    nil
  end

  def deliver!
    emails.each do |email|
      parent = Parent.find(email.parent_id)
      if parent
        kid = Kid.find(email.kid_id)
        if kid
          image_data = image_data_for email

          begin
            parent.deliver(kid, image_data, email.caption)
          rescue => e
            # binding.pry
            nil
          end
        end
      end
      email.delivered = true
      email.save
    end
  end

  def smug_mug_client
    SmugMugWrapper.new.client
  end

  def smug_mug_image_for( email )
    smug_mug_client.find_image \
      email.image_id,
      email.image_key
  end
end
