class RemoveStepField < ActiveRecord::Migration
  def change
    remove_column :env_vars, :step
  end
end
