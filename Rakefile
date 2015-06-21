require 'rake/testtask'

task :test do
  Rake::TestTask.new do |t|
    t.test_files = Dir.glob('test/**/test_*.rb')
    t.warning = true
  end
end

task default: :test
