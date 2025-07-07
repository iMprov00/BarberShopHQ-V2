class CreateBarbers < ActiveRecord::Migration[8.0]
  def change
        create_table :barbers do |t|
          t.text :name

          t.timestamps
        end

        Barber.create :name => 'Максим'
        Barber.create :name => 'Евгений'
        Barber.create :name => 'Виталий'
  end
end
