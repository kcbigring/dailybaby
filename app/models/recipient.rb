class Recipient < ActiveRecord::Base
  belongs_to :user
  belongs_to :delivery, :class_name => "User"
end
