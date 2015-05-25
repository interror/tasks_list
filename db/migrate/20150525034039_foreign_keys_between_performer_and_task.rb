class ForeignKeysBetweenPerformerAndTask < ActiveRecord::Migration
  def change
    add_foreign_key :tasks, :users, column: :performer, primary_key: "id"
  end
end
