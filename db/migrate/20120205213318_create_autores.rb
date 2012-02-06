class CreateAutores < ActiveRecord::Migration
  def change
    create_table :autores do |t|
      t.string :nome
      t.string :lattes
      t.references :conteudo

      t.timestamps
    end
  end
end
