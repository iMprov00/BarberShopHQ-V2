class CreateBarbers < ActiveRecord::Migration[8.0]
  def change
    create_table :barbers do |t|

      t.text :name

      t.timestamps

    end

    Barber.create :name => 'Виталий Ляшко'
    Barber.create :name => 'Ступенко Евгений'

  
  end
end
