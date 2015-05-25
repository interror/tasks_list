class Task < ActiveRecord::Base
  belongs_to :user

  def find_performer
    performer = User.find_by id: self.performer
    return performer.name
  end
end
