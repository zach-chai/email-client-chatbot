class AddSender < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :sender, :string
    rename_column :emails, :name, :subject
  end
end
