#
# Cookbook Name:: oh-my-zsh
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
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

include_recipe "git"
include_recipe "zsh"

search( :users, "shell:*zsh" ).each do |u|
  user_id = u["id"]
  execute "clone oh-my-zsh" do
    command "git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh"
    user user_id
    group user_id
    cwd "/home/#{user_id}"
    creates "/home/#{user_id}/.oh-my-zsh"
  end

  theme = data_bag_item( "users", user_id )["oh-my-zsh-theme"]

  template "/home/#{user_id}/.zshrc" do
    source "zshrc.erb"
    owner user_id
    group user_id
    variables( :theme => ( theme || node[:ohmyzsh][:theme] ))
    action :create_if_missing
  end
end