current_dir = File.dirname(__FILE__)
user = ENV['OPSCODE_USER'] || ENV['USER']
orgname = ENV['ORGNAME'] || "chef"

node_name                user
client_key               "#{ENV['HOME']}/.chef/cymek.local/#{user}.pem"
validation_client_name   "#{orgname}-validator"
validation_key           "#{ENV['HOME']}/.chef/cymek.local/#{orgname}-validator.pem"
chef_server_url          "https://192.168.67.250"
syntax_check_cache_path  "#{ENV['HOME']}/.chef/syntax_check_cache"
cookbook_path            ["#{current_dir}/../cookbooks"]
cookbook_copyright "Rivermeadow.com"
cookbook_license "apachev2"
cookbook_email "rberger@ibd.com"

  
