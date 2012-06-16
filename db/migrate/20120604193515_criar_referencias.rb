class CriarReferencias < ActiveRecord::Migration
  def up
    create_table :referencias do |t|
      t.string :abnt
      t.string :tipo_do_grao
      t.references :usuario
      t.references :referenciavel, :polymorphic => true

      t.timestamps
    end
  end

  def down
    drop_table :referencias
  end
end