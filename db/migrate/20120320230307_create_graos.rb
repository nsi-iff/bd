class CreateGraos < ActiveRecord::Migration
  def change
    create_table :graos do |t|
      t.string :key
      t.string :tipo
      t.references :conteudo

      t.timestamps
    end
  end
end

