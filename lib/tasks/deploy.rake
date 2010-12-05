require 'yaml'

def setup
  if $file_name == nil
    $file_name = 'application.tar.bz2'
    $config = YAML::load_file 'deploy.yml'
  end
end

def header title
  puts "\n"
  puts "******************************"
  puts title
  puts "******************************"
end

def command cmd
  puts cmd
  system cmd
end

desc "Clean files produced by last deploy"
task 'deploy:clean' do |t|
    setup
    header "cleaning"
    command "rm #{$file_name}"
end

desc "Compress the app"
task 'deploy:archive' => ['deploy:clean'] do |t|
    setup
    header "archiving"

    #add items to be compressed here
    items = Array.new
    items << 'script'
    items << 'app'
    items << 'config'
    items << 'db'
    items << 'lib'
    items << 'public'
    items << 'vendor'
    items << 'config.ru'
    items << 'Gemfile'
    items << 'Gemfile.lock'
    items << 'Rakefile'

    files_line = ""
    items.each do |item|
      files_line += " #{item}"   
    end
    files_line.strip!

    command "tar --create --bzip2 --verbose --file=#{$file_name} #{files_line}"
end

desc 'Upload files to server'
task 'deploy:upload' => ['deploy:archive'] do |t|
  setup
  header "uploading"
  command "scp -P #{$config[:scp_port.to_s]} #{$file_name} #{$config[:scp_url.to_s]}"
end



