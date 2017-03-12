class CreateProjectsOutlineSubscribers < ActiveRecord::Migration
  def change
    create_table :projects_outline_subscribers do |t|
      t.string :phone

      t.timestamps null: false
    end
  end
end
