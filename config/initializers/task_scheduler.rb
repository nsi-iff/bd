scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 58 23 * * 1-7' do
  acesso = Acesso.new
  acesso.log_file = "#{Rails.root}/spec/resources/access.log" if Rails.env.test?
  acesso.save
end

scheduler.cron '0 00 2 * * 1-7' do
  Busca.enviar_email_mala_direta
end
