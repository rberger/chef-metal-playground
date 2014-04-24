current_dir = File.dirname(__FILE__)
user = ENV['OPSCODE_USER'] || ENV['USER']
orgname = ENV['ORGNAME'] || "chef"
client_name = `hostname`.downcase.strip
chef_server_url          "https://192.168.67.250"

node_name                user
client_key               "#{ENV['HOME']}/.chef/#{client_name}/#{user}.pem"
validation_client_name   "#{orgname}-validator"
validation_key           "#{ENV['HOME']}/.chef/#{client_name}/#{orgname}-validator.pem"
syntax_check_cache_path  "#{ENV['HOME']}/.chef/syntax_check_cache"
cookbook_path            ["#{current_dir}/../cookbooks"]
cookbook_copyright "Robert J. Berger"
cookbook_license "apachev2"
cookbook_email "rberger@ibd.com"

  
