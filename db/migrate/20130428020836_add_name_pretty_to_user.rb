class AddNamePrettyToUser < ActiveRecord::Migration
  def change
    add_column :users, :name_pretty, :string
  end
end
