class DestroyDocumentoOdts < ActiveRecord::Migration
  def up
    drop_table :documento_odts
  end

  def down
    create_table(:documento_odts) {|t| t.timestamps }
  end
end
