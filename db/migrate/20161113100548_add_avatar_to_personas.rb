class AddAvatarToPersonas < ActiveRecord::Migration[5.0]
  def change
    add_column :personas, :avatar, :string
  end
end
