class CursosObjetosDeAprendizagem < ActiveRecord::Migration
  def up
    create_table :cursos_objetos_de_aprendizagem, :id => false do |t|
      t.references :curso
      t.references :objeto_de_aprendizagem
    end
  end

  def down
    drop_table :cursos_objetos_de_aprendizagem
  end
end
