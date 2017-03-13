class AddPinAndVerifiedToSubscriber < ActiveRecord::Migration
  def change
    add_column :projects_outline_subscribers, :pin, :string
    add_column :projects_outline_subscribers, :verified, :boolean
  end
end
