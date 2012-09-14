#require 'resque/tasks'
#task "resque:setup" => :environment

require 'resque/tasks'

task "resque:setup" =&gt; :environment do
ENV['QUEUE'] = '*'
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" =&gt; "resque:work"