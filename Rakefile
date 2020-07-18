require 'fileutils'
require 'securerandom'
require 'openssl'

ENV['RACK_ENV'] ||= 'development'

namespace :secrets do
  def secret(file)
    path = "#{File.dirname(__FILE__)}/tmp/secrets/#{ENV['RACK_ENV']}/#{file}"
    begin
      File.read(path)
    rescue Errno::ENOENT
      content = yield
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') {|f| f.write(content) }
      content
    end
  end

  desc "Show generated database password"
  task :db_password do
    puts secret('db-password.txt') { SecureRandom.urlsafe_base64 }
  end

  desc "Show generated RSA session key"
  task :session_key do
    puts secret('session-key.pem') { OpenSSL::PKey::RSA.generate(2048) }
  end
end

namespace :container do
  def docker_compose(args)
    trap 'INT', 'IGNORE'
    sh 'bin/docker-compose', *args
  end

  desc "Run app via docker-compose"
  task :up do
    docker_compose %w[up]
  end

  desc "Stop docker-compose containers"
  task :down do
    docker_compose %w[down]
  end

  desc "List running docker-compose processes"
  task :top do
    docker_compose %w[top]
  end

  desc "Run tests in app container"
  task :test do
    ENV['RACK_ENV'] = 'test'
    docker_compose %w[up --detach postgres]
    docker_compose %w[run api rake test]
  end

  desc "Run irb in app container with models loaded"
  task :irb do
    docker_compose %w[run api irb -r ./models]
  end

  namespace :token do
    desc "Generate a token in the app container"
    task :generate do
      docker_compose %w[run api rake token:generate]
    end
  end

  namespace :bundle do
    desc "Run bundle update in app container"
    task :update do
      docker_compose %w[run api bundle update]
    end
  end
end

task :default => :'container:up'
