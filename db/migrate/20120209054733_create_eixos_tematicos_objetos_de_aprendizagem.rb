class CreateEixosTematicosObjetosDeAprendizagem < ActiveRecord::Migration
  def up
    create_table :eixos_tematicos_objetos_de_aprendizagem, :id => false do |t|
      t.references :objeto_de_aprendizagem
      t.references :eixo_tematico
    end
  end

  def down
    drop_table :eixos_tematicos_objetos_de_aprendizagem
  end
end
