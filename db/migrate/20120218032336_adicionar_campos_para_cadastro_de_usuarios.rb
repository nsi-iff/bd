class AdicionarCamposParaCadastroDeUsuarios < ActiveRecord::Migration
  def up
    change_table :usuarios do |t|
      t.string :usuario
      t.string :nome_completo
      t.string :instituicao
      t.string :campus
    end
  end

  def down
    change_table :usuarios do |t|
      t.remove :usuario
      t.remove :nome_completo
      t.remove :instituicao
      t.remove :campus
    end
  end
end
