class CriarCurso < ActiveRecord::Migration
  def change
    create_table :cursos do |t|
      t.string :nome
      t.references :eixo_tematico

      t.timestamps
    end
  end
end
