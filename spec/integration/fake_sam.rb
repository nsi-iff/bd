require 'rbconfig'
require 'open-uri'

def app_file
  File.expand_path(File.join(File.dirname(__FILE__), 'fake_sam_app.rb'))
end

def port
  9999
end

def command
  cmd = ['exec']
  if RbConfig.respond_to? :ruby
    cmd << RbConfig.ruby.inspect
  else
    file, dir = RbConfig::CONFIG.values_at('ruby_install_name', 'bindir')
    cmd << File.expand_path(file, dir).inspect
  end
  cmd << app_file.inspect << '-p' << port << '2>&1'
  cmd.join(' ')
end

def kill(pid, signal = 'TERM')
  Process.kill(signal, pid)
rescue NotImplementedError
  system "kill -s #{signal} #{pid}"
end

def fake_sam_up
  @pipe = IO.popen(command)
  wait_for_server_up
end

def fake_sam_down
  kill(@pipe.pid) if @pipe
  wait_for_server_down
end

def wait_for_server_up
  URI.parse("http://localhost:#{port}?key=123").read
rescue Errno::ECONNREFUSED
  sleep 0.1
  retry
end

def wait_for_server_down
  while true
    URI.parse("http://localhost:#{port}?key=123").read
    sleep 0.1
  end
rescue Errno::ECONNREFUSED
end
