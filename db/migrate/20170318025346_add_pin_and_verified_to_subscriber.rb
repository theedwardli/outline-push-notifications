class AddPinAndVerifiedToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :pin, :string
    add_column :subscribers, :verified, :boolean
  end
end
