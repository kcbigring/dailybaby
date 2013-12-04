namespace :dailybaby do
  
  desc "deliver emails"
  task :deliver => :environment do
    puts 'sending daily emails...'
    ScheduledEmail.where(:delivered => false).each do |email|
      parent = Parent.find(email.parent_id)
      kid = Kid.find(email.kid_id)
      image_url = SmugMugWrapper.new.get_image_url(email.image_id, email.image_key, kid.album.password) rescue nil
      parent.deliver(kid, image_url, email.caption) rescue nil
      email.delivered = true
      email.save
    end
  end
  
end