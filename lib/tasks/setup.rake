file 'config/secrets.yml' => 'config/secrets.yml.example' do |task|
  cp task.prerequisites.first, task.name
end

desc <<-DESC.strip_heredoc
  Performs set up before running in development or test environments
DESC
task :setup, [] do
  Rake::Task['config/secrets.yml'].invoke
end
