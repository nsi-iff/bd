class CreateBusca < ActiveRecord::Migration
  def self.up
    create_table :buscas do |t|
      t.string :busca
      t.string :titulo
      t.text :descricao
      t.belongs_to :usuario

      t.timestamps
    end
  end

  def self.down
    drop_table :buscas
  end
end
