require 'chef_metal_docker'

with_provisioner ChefMetalDocker::DockerProvisioner.new

with_provisioner_options 'base_image' => 'ubuntu:precise'

execute 'docker pull ubuntu'
