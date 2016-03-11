require 'serverspec'

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end

def service_name_for(service)
  case service
  when 'ssh'
    if %w(debian ubuntu).include?(os[:family])
      'ssh'
    elsif %w(centos redhat fedora).include?(os[:family])
      'sshd'
    end
  end
end
