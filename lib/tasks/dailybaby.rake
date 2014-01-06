namespace :dailybaby do
  
  desc "deliver emails"
  task :deliver => :environment do
    puts 'sending daily emails...'
    ScheduledEmail.where(:delivered => false).each do |email|
      parent = Parent.find(email.parent_id)
      if parent
        kid = Kid.find(email.kid_id)
        if kid
          begin
            image =
              SmugMugWrapper.new.client.find_image \
                email.image_id,
                email.image_key

            image_url =
              {
                :medium   => image.mediumurl,
                :original => image.originalurl
              }
          rescue
            image_url = nil
          end

          parent.deliver(kid, image_url, email.caption) rescue nil
        end
      end
      email.delivered = true
      email.save
    end
  end
  
end
