class ChangePerformerType < ActiveRecord::Migration
  def change
    change_column(:tasks, :performer, :fixnum)
  end
end
