require 'chef_metal'

machine 'mario' do
  action :delete
end

num_webservers = 1

1.upto(num_webservers) do |i|
  machine "luigi#{i}" do
    action :delete
  end
end
