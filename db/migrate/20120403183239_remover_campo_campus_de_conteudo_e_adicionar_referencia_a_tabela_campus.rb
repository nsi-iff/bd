class RemoverCampoCampusDeConteudoEAdicionarReferenciaATabelaCampus < ActiveRecord::Migration
  def up
   change_table :conteudos do |t|
      t.remove :campus

      t.references :campus
    end
  end

  def down
    change_table :conteudos do |t|
      t.string :campus

      t.remove :campus_id
    end
  end
end
