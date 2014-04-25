name             'myapp'
maintainer       'Robert J. Berger'
maintainer_email 'rberger@ibd.com'
license          'apachv2'
description      'Installs/Configures myapp with chef-metal'
long_description 'Installs/Configures myapp with chef-metal'
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

%w(apt sshd supervisord).each do |dep|
  depends dep
end

