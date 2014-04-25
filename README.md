# Overview

## Status

__UNDER CONSTRUCTION__ _Not yet working fully_

As of April 24, 2014:

* The vagrant version works fine. (but doesn't really do anything)
* The docker version "succeeds" but doesn' leave a running container
    * The chef-client run on my workstation completes without error,
    * Creates the image / container
    * Runs the chef-client on the container and succeeds.
    * __BUT__ the container then exits and is no longer available

So I'm trying to figure out how to get the container to stay up and
act like a vm.

## Chef-Repo for testing chef-metal cluster

This is a base chef repo with an app cookbook `myapp` for trying out
chef-metal and various chef-metal provisioners. It primiarily will be
using a real Chef Server and not chef-server mainly because that is my
use case and is not yet well documented.

This first experiment is trying to use Docker containers to act like
lightweight VMs so we can simulate a cluster of servers on a laptop.
This is not the "docker way" but it solves and immediate need until we
can figure out how to fully utilize docker for compositing services
into servers.

# Prerequeistes / Assumptions

These are the environment I developed under. YMMV if you don't use the
same. Probably not all hard and fast but variation increases
uncertainty.

* Ruby 2.1.1 via rvm
* Bundler installs all the gems in an rvm gemset
    * This repo sets a gemset and ruby version use `.ruby-*` files in
      the root of the repo
    * Chef 11.12+ installed as gems by bundler
    * Chef-metal and the provisioneres are installed by bundler
    * Berkshelf 3.1.1
* A real Chef Server

# Set things up

## Have a Chef Server

Have some kind of Chef Server running that you can add users,
cookbooks, nodes, clients etc. to . It can be Hosted/Private
Enterprise Chef or Open Source Chef Server. These examples were tested
with Open Source Chef Server.

## Set up this repo to your workstation

We're assuming a Mac. Should work elsewhere but I haven't tested it.

### Clone the repo

```
git clone https://github.com/rberger/chef-metal-playground
```

This includes an app cookbook in my_cookbooks. Berkshelf will use this
directory to get cookbooks that are specific to the playground and
then get the rest of the cookbooks from the community site or other
sites as specified in the Berksfile.

### Bundle install

```
bundle install
```

### Berkshelf install

This will pull in any cookbooks and the `berks vendor cookbooks` will
copy the cookbooks into the cookbooks directory

```
berks install
berks vendor cookbooks
```

### Set up your .chef directory in this repo

The existing .chef/knife.rb is set up with the following assumptions.
Feel free to change for your environment:

* Your chef-server chef-validator and user pem will be in
  `~/.chef/#{HOSTNAME}/  
    (This insures that your creds don't end up in your git repo)
* You need to change the chef_server_url to match your chef servers
  FQDN or ip address
* It trys to figure out the username and orgname if appropriate


## Set up to run chef-client on your workstation

## Install Docker

* http://docs.docker.io/installation/mac/
* export DOCKER_HOST=tcp://localhost:4243

## Create an admin client on your chef server

As far as I can tell, if you are running Open Source Chef Server, you
need to have a client on your chef server that has admin credentials
since the chef-client run on your workstation will need permission to
create, modify and destroy nodes and other data on the chef-server.

If you were running Enterprise Chef Server you can have finer control
of the permissions for the chef-client you run on your workstation.

Make sure you save the private key that gets generated when you create
the new client on your chef server. You can name it what you want but
you eill have to put that name into the `/etc/chef/client.rb` we are
going to create below.

Our example client will be named `rberger_cymek`. Make sure you say it
has `admin` power when you create it. 

## Set up your `/etc/chef`

We're going to be running `chef-client` on your workstation, not to
manage your workstation but to bring up the target instances. If you
do use chef for managing your workstation (i.e. if there already
exists an `/etc/chef` directory on your workstation) you should not
follow these instructions or back up your /etc/chef.

There are ways to not depend on /etc/chef (like merge it into knife.rb
and pass that to the chef-client run with the `-c` flag) for this but
I didn't want to add that complexitity right now


* Create the directory

```
mkdir -p /etc/chef
```

* Copy creds to `/etc/chef`

Copy the client pem (`rberger_cymek.pem` in our example) you created
on your chef-server when you created the client with admin permissions
to /etc/chef. Then change permissions to not allow others to access
it.

```
chmod og-rwx /etc/chef/rberger_cymek.pem
```

* Create the `/etc/chef/client.rb`

This is what I used. You will have to change `rberger_cymek` to
whatever you called your client on the chef-server and also set the
proper `chef_server_url`

```
current_dir = File.dirname(__FILE__)
user = ENV['OPSCODE_USER'] || ENV['USER']
base_dir = "#{current_dir}"
node_name               "rberger_cymek"
chef_server_url         "https://chef-server.local"
client_key              "#{base_dir}/rberger_cymek.pem"

checksum_path           "#{base_dir}/checksum"
file_cache_path         "#{base_dir}/cache"
file_backup_path        "#{base_dir}/backup"
cache_options({:path => "#{base_dir}/cache/checksums", :skip_expires => true})
ssl_verify_mode         :verify_none
```


# Deploying instances with Chef-Metal

One of the great features of Chef-Metal is that you can create
cookbook for building a cluster of instances (servers) and decouple
the target infrastructure (provisioner) from the description of how
the instance (machine) is defined.

The cookbook `myapp` in `my_cookbooks/myappp` is a cluster cookbook.

The goal of the cookbook is to show how to bring up machines with
chef-metal and an open source chef-server (not chef-zero) and be able
to target different provisioners by including the appropriate recipe
in the run list (`vagrant.rb` and `docker.rb` for now).

The first attempt is to get a docker container to come up and stay up
with ssh enabled.

In  `my_cookbooks/myappp/recipes` there are the following  recipes:

* `my_machines.rb`: The actual machine[s] to build
* `chefserver.rb`: Specifies chef-server to be used by the instances
  when they run their local chef-client runs. Should be the first
  thing in your run_list if you are using a real chef-server (only
  tested this way and using Open Source Chef Server)
* `vagrant.rb`: Include this in the run list if you want to target the
Vagrant provisioner
* `docker.rb`: Include this in the run list if you want to target the
  docker provisioner. Right now this also has the command that should
  be run after the local chef-client run (though right now, Apr 24,
  2014, its not running that command)
* `delete_machines.rb`: Will delete the machines (This will probably
  go away once I figure out how to do this correctly)

## Deploying a server with Vagrant


```
chef-client -o myapp::chefserver,myapp::vagrant,myapp::my_machines -l info
```

## Deploying a server to Docker

```
chef-client -o myapp::chefserver,myapp::docker,myapp::my_machines -l info
```
