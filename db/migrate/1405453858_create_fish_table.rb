class CreateFishTable < ActiveRecord::Migration
  def up
    create_table :fishes do |t|
      t.string :name
      t.string :url
      t.integer :user_id
    end
  end

  def down
    drop_table :fishes
  end
end
