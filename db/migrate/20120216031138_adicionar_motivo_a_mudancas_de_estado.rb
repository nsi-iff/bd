class AdicionarMotivoAMudancasDeEstado < ActiveRecord::Migration
  def up
    add_column :mudancas_de_estado, :motivo, :string # para o estado 'remover'
  end

  def down
    remove_column :mudancas_de_estado, :motivo
  end
end
