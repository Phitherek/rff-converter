class CreateConversions < ActiveRecord::Migration
  def change
    create_table :conversions do |t|
      t.belongs_to :key
      t.string :original_file
      t.string :zippath
      t.string :convtype
      t.string :status
      t.string :mode
      t.decimal :percentage
      t.text :debuginfo1
      t.text :debuginfo2
      t.text :debuginfo3
      t.timestamps
    end
  end
end
