# PURPOSE:
# Prevent data from being altered by rake commands in the production environment

# SOURCE:
# http://www.developingandrails.com/2015/01/disable-dangerous-rake-tasks-in.html

# Commands for overriding the restrictions:
# I_KNOW_THIS_MAY_SCREW_THE_DB=1 RAILS_ENV=production rails db:drop
# I_KNOW_THIS_MAY_SCREW_THE_DB=1 RAILS_ENV=production rails db:migrate:reset
# I_KNOW_THIS_MAY_SCREW_THE_DB=1 RAILS_ENV=production rails db:schema:load
# I_KNOW_THIS_MAY_SCREW_THE_DB=1 RAILS_ENV=production rails db:seed

DISABLED_TASKS = ['db:drop', 'db:migrate:reset', 'db:schema:load',
                  'db:seed'].freeze

namespace :db do
  desc 'Disable a task in production environment'
  task :guard_for_production do
    if Rails.env.production?
      if ENV['I_KNOW_THIS_MAY_SCREW_THE_DB'] != '1'
        puts 'This task is disabled in production.'
        puts 'If you really want to run it, '
        puts 'call it again with `I_KNOW_THIS_MAY_SCREW_THE_DB=1`'
        exit
      end
    end
  end
end

DISABLED_TASKS.each do |task|
  Rake::Task[task].enhance ['db:guard_for_production']
end
