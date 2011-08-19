class JunkData < ActiveRecord::Migration
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
      t.decimal :decimal
      t.float :float
      t.integer :range
      t.string :password
      t.string :query   
      
      t.boolean :checkable   

      t.timestamps
    end
  end

  def self.down
    drop_table :elements
  end
end
