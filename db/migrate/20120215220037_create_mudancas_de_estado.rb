class CreateMudancasDeEstado < ActiveRecord::Migration
  def change
    create_table :mudancas_de_estado do |t|
      t.references :usuario
      t.references :conteudo
      t.string :de
      t.string :para

      t.timestamps
    end
    add_index :mudancas_de_estado, :usuario_id
    add_index :mudancas_de_estado, :conteudo_id
  end
end
