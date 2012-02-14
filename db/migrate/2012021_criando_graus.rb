class CriandoGraus < ActiveRecord::Migration
  def up
    create_table :graus do |t|
      t.string :nome

      t.timestamps
    end
  end
end
