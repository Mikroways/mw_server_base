require 'spec_helper'

describe 'mw_server_base::basic_packages' do
  debian_packages = %w(atsar vim locate apt-utils bsdutils htop tmux rsync iftop iotop telnet tcpdump strace sysstat ngrep iproute)
  rhel_packages = %w(vim mlocate tmux rsync iotop telnet tcpdump strace sysstat htop iftop ngrep iproute)

  platforms_to_test = {
    'ubuntu' => {
      '14.04' => debian_packages
    },
    'debian' => {
      '7.0' => debian_packages
    },
    'centos' => {
      '6.5' => rhel_packages
    },
    'redhat' => {
      '7.1' => rhel_packages
    }
  }

  platforms_to_test.each do |platform, versions|
    versions.each do |version, packages|
      describe "packages setup on platform #{platform}" do
        cached(:chef_run) do
          chef_run = ChefSpec::SoloRunner.new(platform: platform, version: version)
          chef_run.converge(described_recipe)
        end

        packages.each do |package_name|
          it "should install #{package_name} on #{platform} #{version}" do
            expect(chef_run).to install_package(package_name)
          end
        end
      end
    end
  end
end
