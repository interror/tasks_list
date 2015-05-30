class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :performer, class_name: "User", :foreign_key => "performer"

end
