class CreateBarbers < ActiveRecord::Migration[8.0]
  def change
    create_table :barber do |t|

      t.text :name

      t.timestamps

    end
  end
end
