namespace :rasper do
  task :pom do
    print "Generating pom.xml..."
    path = File.join(File.expand_path(File.dirname(__FILE__)), 'java', 'pom.xml')
    File.open('./pom.xml', 'w') {|f| f.write(File.read(path)) }
  end
end