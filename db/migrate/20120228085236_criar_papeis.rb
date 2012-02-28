class CriarPapeis < ActiveRecord::Migration
  def up
    create_table :papeis do |t|
      t.string :nome
    end
  end
  def down
    drop_table :papeis
  end
end
