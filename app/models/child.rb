class Child < ActiveRecord::Base
  belongs_to :user
  belongs_to :kid, :class_name => "User"
end
