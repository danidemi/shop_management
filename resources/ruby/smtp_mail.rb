require 'net/smtp'
require 'socket'

msgstr = <<END_OF_MESSAGE
From: Your Name <g@g.g>
To: Destination Address <g@g.g>
Subject: test message
Date: #{Time.now}
Message-Id: <#{Time.now.to_f}@g.g>

This is a test message sent from #{Socket.gethostname}
END_OF_MESSAGE

Net::SMTP.start('localhost', 25) do |smtp|
  puts msgstr
  smtp.send_message msgstr, 'g@g.g', 'g@g.g'
end


msgstr = <<END_OF_MESSAGE
From: Your Name <g@g.g>
To: Destination Address <g@g.g>
Subject: another test message
Date: #{Time.now}
Message-Id: <#{Time.now.to_f}@g.g>

This is a test message sent from #{Socket.gethostname}
END_OF_MESSAGE

Net::SMTP.start('localhost', 25) do |smtp|
  puts msgstr
  smtp.send_message msgstr, 'noreply@g.g', 'demichelis@g.g'
end

