class AddVerficationTo < ActiveRecord::Migration
  def change
    add_column :users, :verified, :boolean
    add_column :users, :verification_pass, :string
  end
end
