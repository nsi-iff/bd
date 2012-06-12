namespace :db do
  desc "Drop, create, migrate then seed the database"
  task :reset_db => :environment do
    Rake::Task['db:drop:all'].invoke
    Rake::Task['db:create:all'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['db:fixtures:load'].invoke
  end
end

