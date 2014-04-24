require 'chef_metal'

machine 'mario' do
  recipe 'postgresql'
  tag 'mydb_master'
end

# num_webservers = 1

# 1.upto(num_webservers) do |i|
#   machine "luigi#{i}" do
#     recipe 'apache'
#   end
# end
