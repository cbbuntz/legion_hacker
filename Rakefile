require 'rubocop/rake_task'

task default: :rubocop

RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = ['-a']
end

task :test do
  ruby 'test/alienlang.rb'
end