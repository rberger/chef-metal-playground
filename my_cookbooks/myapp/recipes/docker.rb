# Cookbook Name:: myapp
# Recipe:: docker
#
# Copyright (C) 2014 Robert J. Berger
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Include this recipe in your runlist if you want to use the docker provisioner

require 'chef_metal_docker'

with_provisioner ChefMetalDocker::DockerProvisioner.new

with_provisioner_options 'base_image' => 'ubuntu:precise',  'create_container' => { 'command' =>  '/usr/sbin/sshd -D'}

execute 'docker pull ubuntu'
