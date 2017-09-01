# rubocop:disable Metrics/LineLength
# rubocop:disable Style/PercentLiteralDelimiters
# rubocop:disable Style/UnneededPercentQ

require 'line_containing'
require 'remove_double_blank'
require 'string_in_file'

# Get input arguments (called by Bash script)
db_name_dev = ARGV[0]
db_name_test = ARGV[1]
db_name_pro = ARGV[2]
var_store_username = ARGV[3]
var_store_password = ARGV[4]
username_x = ARGV[5]
password_x = ARGV[6]

puts
puts '+++++++++++++++++++++'
puts 'Setting up PostgreSQL'

puts
puts '---------------------------------------------'
puts 'Setting up the PostgreSQL database parameters'
ENV['APP_DB_NAME_DEV'] = db_name_dev
ENV['APP_DB_NAME_TEST'] = db_name_test
ENV['APP_DB_NAME_PRO'] = db_name_pro
ENV['APP_DB_USER'] = username_x
ENV['APP_DB_PASS'] = password_x
system(%q{sudo -u postgres psql -c"CREATE ROLE $APP_DB_USER WITH CREATEDB LOGIN PASSWORD '$APP_DB_PASS';"})

# Development database
system(%q{sudo -u postgres psql -c"CREATE DATABASE $APP_DB_NAME_DEV WITH OWNER=$APP_DB_USER;"})
system('wait')

# Testing database
system(%q{sudo -u postgres psql -c"CREATE DATABASE $APP_DB_NAME_TEST WITH OWNER=$APP_DB_USER;"})
system('wait')

# Production database
system(%q{sudo -u postgres psql -c"CREATE DATABASE $APP_DB_NAME_PRO WITH OWNER=$APP_DB_USER;"})
system('wait')

puts '--------------------------------------------------'
puts 'Using Figaro to create initial configuration files'
system('rm config/application.yml')
system('figaro install')
system('wait')

puts
puts '---------------------------------'
puts 'Setting up config/application.yml'
open('config/application.yml', 'a') do |f|
  f.puts "\n\n"
  f.puts 'VAR_STORE_USERNAME: "USERNAME123"'
  f.puts "\n"
  f.puts 'VAR_STORE_PASSWORD: "PASSWORD123"'
end
StringInFile.replace('VAR_STORE_USERNAME', var_store_username, 'config/application.yml')
StringInFile.replace('USERNAME123', username_x, 'config/application.yml')
StringInFile.replace('VAR_STORE_PASSWORD', var_store_password, 'config/application.yml')
StringInFile.replace('PASSWORD123', password_x, 'config/application.yml')

puts '----------------------'
puts 'Updating build_fast.sh'
StringInFile.replace('sh pg-start.sh', 'sh pg_setup.sh', 'build_fast.sh')

puts
puts '------------------------------'
puts 'Setting up config/database.yml'
system 'cp config/database-pg.yml config/database.yml'
StringInFile.replace('VAR_STORE_USERNAME', var_store_username, 'config/database.yml')
StringInFile.replace('VAR_STORE_PASSWORD', var_store_password, 'config/database.yml')
StringInFile.replace('DB_NAME_DEV', ENV['APP_DB_NAME_DEV'], 'config/database.yml')
StringInFile.replace('DB_NAME_TEST', ENV['APP_DB_NAME_TEST'], 'config/database.yml')
StringInFile.replace('DB_NAME_PRO', ENV['APP_DB_NAME_PRO'], 'config/database.yml')

puts
puts '----------------'
puts 'Updating Gemfile'
LineContaining.delete_between_plus('# BEGIN: SQLite', '# END: SQLite', 'Gemfile')
RemoveDoubleBlank.update('Gemfile')

puts
puts '--------------------'
puts 'Database parameters:'
puts
puts "Name of database (development): #{db_name_dev}"
puts "Name of database (testing): #{db_name_test}"
puts "Name of database (production): #{db_name_pro}"
puts
puts "Environmental variable (stores username): #{var_store_username}"
puts "Environmental variable (stores password): #{var_store_password}"
puts
puts "Username: #{username_x}"
puts "Password: #{password_x}"
puts
puts 'The username and password of the databases are stored at config/application.yml.'
puts 'The database parameters are called at config/database.yml.'

puts
puts 'Finished setting up PostgreSQL'
puts '++++++++++++++++++++++++++++++'
puts

# rubocop:enable Metrics/LineLength
# rubocop:enable Style/PercentLiteralDelimiters
# rubocop:enable Style/UnneededPercentQ
