class RemoverMensagemDeNotificacoes < ActiveRecord::Migration
  def up
    change_table :notificacoes do |t|
      t.remove :mensagem
    end
  end

  def down
    change_table :notificacoes do |t|
      t.text :mensagem
    end
  end
end
