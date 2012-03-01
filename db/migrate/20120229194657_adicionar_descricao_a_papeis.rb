class AdicionarDescricaoAPapeis < ActiveRecord::Migration
  def up
    add_column :papeis, :descricao, :string
  end

  def down
    remove_column :papeis, :descricao
  end
end

