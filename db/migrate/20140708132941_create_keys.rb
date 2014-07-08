class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :keystring
      t.timestamps
    end
  end
end
