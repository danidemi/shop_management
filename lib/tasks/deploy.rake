require 'yaml'

def setup
  if $file_name == nil
    $file_name = 'application.tar.bz2'
    $config = YAML::load_file 'deploy.yaml'
  end
end

desc "Clean files produced by last deploy"
task 'deploy:clean' do |t|
    setup
    puts "cleaning"
    system "rm #{$file_name}"
end

desc "Compress the app"
task 'deploy:archive' => ['deploy:clean'] do |t|
    setup
    puts "archiving"

    #add items to be compressed here
    items = Array.new
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

    system "tar --create --bzip2 --file=#{$file_name} #{files_line}"
end

desc 'Upload files to server'
task 'deploy:upload' do |t|
  setup
  system "scp -P #{$config[:stp_port.to_s]} #{$file_name} #{$config[:stp_url.to_s]}"
end



