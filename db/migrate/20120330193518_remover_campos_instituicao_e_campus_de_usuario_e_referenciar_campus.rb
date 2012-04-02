class RemoverCamposInstituicaoECampusDeUsuarioEReferenciarCampus < ActiveRecord::Migration
  def up
    change_table :usuarios do |t|
      t.remove :instituicao
      t.remove :campus

      t.references :campus
    end
  end

  def down
    change_table :usuarios do |t|
      t.string :instituicao
      t.string :campus

      t.remove :campus_id
    end
  end
end
