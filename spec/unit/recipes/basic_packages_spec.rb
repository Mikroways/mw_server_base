require 'chefspec'

describe 'mw_server_base::basic_packages' do
  debian_packages = %w(atsar vim locate apt-utils bsdutils htop tmux rsync iftop iotop telnet tcpdump strace sysstat ngrep)
  rhel_packages = %w(vim mlocate htop tmux rsync iftop iotop telnet tcpdump strace sysstat ngrep)

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
      packages.each do |package_name|
        it "should install #{package_name} on #{platform} #{version}" do
          chef_runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          chef_runner.converge(described_recipe)
          expect(chef_runner).to install_package(package_name)
        end
      end
    end
  end
end
