class CreateDocumentoOdts < ActiveRecord::Migration
  def change
    create_table :documento_odts do |t|

      t.timestamps
    end
  end
end
