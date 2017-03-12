class AddOutlineSubscriberPhoneIndex < ActiveRecord::Migration
  def change
  	add_index :projects_outline_subscribers, :phone, unique: true
  end
end
