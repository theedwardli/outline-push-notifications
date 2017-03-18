class AddSubscriberPhoneIndex < ActiveRecord::Migration
  def change
  	add_index :subscribers, :phone, unique: true
  end
end
