every 1.day, :at => '10:00 am' do
  rake "dailybaby:deliver"
end

every 1.day, :at => '5:30 pm' do
  rake "dailybaby:send_reminders"
end
