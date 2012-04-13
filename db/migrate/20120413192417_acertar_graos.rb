class AcertarGraos < ActiveRecord::Migration
  def up
    change_table :graos do |t|
      t.remove :link
      t.string :tipo
      t.string :key
    end
  end

  def down
    change_table :graos do |t|
      t.string :link
      t.remove :tipo
      t.remove :key
    end
  end
end

