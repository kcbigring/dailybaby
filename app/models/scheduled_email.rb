class ScheduledEmail < ActiveRecord::Base
  belongs_to :parent
  belongs_to :kid
end
