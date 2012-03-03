class AlterarTipoDeGrandeAreaEAreaParaInteiroEmConteudos < ActiveRecord::Migration
  def up
    change_table :conteudos do |t|
      t.remove :grande_area_de_conhecimento
      t.remove :area_de_conhecimento
      t.integer :grande_area_de_conhecimento
      t.integer :area_de_conhecimento
    end
  end

  def down
    change_table :conteudos do |t|
      t.change :grande_area_de_conhecimento, :string
      t.change :area_de_conhecimento, :string
    end
  end
end
