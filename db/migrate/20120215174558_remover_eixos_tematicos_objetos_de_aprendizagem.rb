class RemoverEixosTematicosObjetosDeAprendizagem < ActiveRecord::Migration
  def up
    drop_table :eixos_tematicos_objetos_de_aprendizagem
  end

  def down
    create_table :eixos_tematicos_objetos_de_aprendizagem, :id => false do |t|
      t.references :objeto_de_aprendizagem
      t.references :eixo_tematico
    end
  end
end
