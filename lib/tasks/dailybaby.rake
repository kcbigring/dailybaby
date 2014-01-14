namespace :dailybaby do
  desc 'deliver emails'
  task :deliver => :environment do
    RecipientEmails.deliver
  end

  desc 'send reminders'
  task :send_reminders => :environment do
    ParentReminders.deliver
  end
end
