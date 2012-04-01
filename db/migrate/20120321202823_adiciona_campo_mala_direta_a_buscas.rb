class AdicionaCampoMalaDiretaABuscas < ActiveRecord::Migration
  def up
    add_column :buscas, :mala_direta, :boolean, :default => false
  end

  def down
    remove_column :buscas, :mala_direta
  end
end
