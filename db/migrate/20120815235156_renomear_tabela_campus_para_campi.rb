class RenomearTabelaCampusParaCampi < ActiveRecord::Migration
  def up
    rename_table :campus, :campi
  end

  def down
    rename_table :campi, :campus
  end
end
