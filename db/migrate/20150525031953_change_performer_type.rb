class ChangePerformerType < ActiveRecord::Migration
  def change
    execute 'ALTER TABLE tasks ALTER COLUMN performer TYPE integer USING (performer::integer)'
  end
end
