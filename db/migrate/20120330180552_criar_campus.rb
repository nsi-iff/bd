class CriarCampus < ActiveRecord::Migration
  def change
    create_table :campus do |t|
      t.string :nome
      t.references :instituicao

      t.timestamps
    end
  end
end
