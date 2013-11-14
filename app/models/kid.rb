class Kid < User
  has_many :inverse_chidren, :class_name => "Child", :foreign_key => "child_id"
  has_many :parents, :through => :inverse_chidren, :source => :user
  
  has_one :album
  accepts_nested_attributes_for :album, allow_destroy: true, reject_if: lambda {|attributes| attributes['smugmug_id'].blank?}
end
