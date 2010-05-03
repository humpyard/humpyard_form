class CreateElements < ActiveRecord::Migration
  def self.up
    create_table :elements do |t|
      t.string :title
      t.text :description
      
      t.string :phone
      t.string :url
      t.string :email
            
      
      t.date :date
      t.time :time
      t.datetime :datetime

      t.string :week
      t.string :month

      t.string :color
      t.integer :number
      t.string :password
      t.string :query      

      t.timestamps
    end
  end

  def self.down
    drop_table :elements
  end
end
