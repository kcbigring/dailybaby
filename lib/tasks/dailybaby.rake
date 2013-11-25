namespace :dailybaby do
  
  desc "deliver emails"
  task :deliver => :environment do
    puts 'sending daily emails...'
    ScheduledEmail.where(:delivered => false).each do |email|
      parent = Parent.find(email.parent_id)
      parent.deliver(Kid.find(email.kid_id), SmugMugWrapper.new.get_image_url(email.image_id, email.image_key), email.caption) rescue nil
      email.delivered = true
      email.save
    end
  end
  
end