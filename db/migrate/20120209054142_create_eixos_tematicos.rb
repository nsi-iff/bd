class CreateEixosTematicos < ActiveRecord::Migration
  def change
    create_table :eixos_tematicos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
