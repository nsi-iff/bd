class RemoverGrandeAreaEAreaECriarReferenciaParaSubAreaEmConteudos < ActiveRecord::Migration
  def up
		change_table :conteudos do |t|
			t.remove :grande_area_de_conhecimento
			t.remove :area_de_conhecimento
			t.references :sub_area
		end
  end

  def down
		change_table :conteudos do |t|
			t.integer :grande_area_de_conhecimento
			t.integer :area_de_conhecimento
			t.remove :sub_area_id
		end
  end
end
