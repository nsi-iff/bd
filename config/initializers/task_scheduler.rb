scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 58 23 * * 1-5' do
  acesso = Acesso.new
  if Rails.env == 'test'
    acesso.log_file = "#{Rails.root}/spec/resources/access.log"
  end
  acesso.save
end

scheduler.cron '0 00 2 * * 1-5' do
  Busca.enviar_email_mala_direta
end