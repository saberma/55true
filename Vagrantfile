Vagrant::Config.run do |config|
  config.vm.box = "lucid32"

  config.vm.forward_port "nodejs", 3000, 3000

  #config.vm.provision :chef_solo do |chef|
  #  #chef.recipe_url = "https://dl.dropbox.com/u/19519145/shopqi/chef-solo.tar.gz"
  #  chef.cookbooks_path = "/home/saberma/Documents/chef-repo/cookbooks"
  #  chef.add_recipe "apt"
  #  chef.add_recipe "nodejs::npm"
  #  chef.log_level = :debug
  #end

end
