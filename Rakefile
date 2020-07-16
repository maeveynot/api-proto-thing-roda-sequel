require 'rake/testtask'

namespace :spec do
  %i[model web].each do |s|
    Rake::TestTask.new(s) do |t|
      desc "Run #{s} specs"
      t.test_files = FileList["spec/#{s}/**/*_spec.rb"]
      t.verbose = true
    end
    task s => :'db:migrate:up'
  end

  desc "Run all specs"
  task all: %i[model web]
end

desc "Run tests"
task test: :'spec:all'
task default: :test

namespace :db do
  task :create do
    raise "not implemented"
  end

  namespace :migrate do
    def migrate(version)
      require_relative 'db'
      require 'logger'
      Sequel.extension :migration
      DB.loggers << Logger.new($stdout) if DB.loggers.empty?
      Sequel::Migrator.apply(DB, 'migrate', version)
    end

    desc "Apply all migrations"
    task :up do
      migrate(nil)
    end
    desc "Roll back all migrations"
    task :down do
      migrate(0)
    end
    desc "Roll back and re-apply all migrations"
    task bounce: %i[down up]
  end
end

desc "Annotate Sequel models"
task :annotate do
  raise "please run in development" unless ENV['RACK_ENV'] == 'development'
  require_relative 'models'
  require 'sequel/annotate'
  DB.loggers.clear
  Sequel::Annotate.annotate(Dir['models/*.rb'])
end

namespace :token do
  desc "Generate a valid JWT"
  task :generate do
    #require 'rack/ssl-enforcer'
    require_relative 'lib/session'
    puts Plum::Session.token
  end
end

desc "Run irb with models loaded"
task :irb do
  trap 'INT', 'IGNORE'
  sh 'irb', '-r', './models'
end
