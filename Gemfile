source 'http://rubygems.org'

# need gem install bundler -v 1.0.0.rc.1
gem 'rails'

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

##### 实体相关 #####
gem 'mongoid', '2.0.0.beta.19'
gem 'bson_ext'
gem 'devise'

# 文件上传
# 2010.08.13 源版本不支持mongoid校验，已提交补丁，已合并至官方版本
gem "carrierwave"
# 调用参数说明:http://www.imagemagick.org/Usage/
gem "mini_magick"


##### 视图相关 #####
gem 'haml'
# 注意页面的html元素要有xmlns属性，否则fieldset会挤在一起 http://bit.ly/bbcxU3
gem "formtastic"
# 用于formtastic读取实体校验规则，页面可直接展示属性是否必填
gem "validation_reflection"


##### 控制器相关 #####
gem "inherited_resources"

##### 样式相关 #####
gem 'compass'

# 调试
gem "awesome_print", :require => 'ap'

group :development do
  gem 'html5-boilerplate'
  gem 'rails3-generators'
  # jquery,haml已经独立出来
  gem "jquery-rails"
  gem "haml-rails"
  # 修改后台文件后，safari或chrome浏览器会自动刷新
  gem "livereload"
  gem "rb-inotify"

  # To use debugger(add 'debugger' in code, then set autoeval; set autolist in console)
  gem 'ruby-debug19'
  # 需要手动安装(/path/to/ruby为ruby所在路径，如:home/saberma/.rvm/src/ruby-1.9.2-head)
  # gem install ruby-debug19 --no-ri --no-rdoc -- --with-ruby-include=/path/to/ruby
end

group :test do
  gem 'webrat'
  gem "rspec-rails"
  gem "factory_girl"
  gem "factory_girl_rails"

  # 最新版本0.4.0有问题，无法启动测试服务器
  gem 'capybara', '0.3.9'
  # 保持数据库处理干净状态
  # 留意:步骤完成后就会清除数据，此时浏览器中部分ajax可能还没有操作完，会导致ajax请求时找不到相应数据
  gem 'database_cleaner'
  # 0.9.2版本集成spork的情况下会报undefined method `visit' for #<Object:
  gem 'cucumber'
  gem 'cucumber-rails'
  # 为测试加速的drb server(sport cuc &)
  # 不要使用rspec2.0.0.beta.16版本，执行rspec -X
  # Exception encountered: #<NoMethodError: undefined method `configure' for ["--color", "spec/models/nav_spec.rb"]:Array>
  gem 'spork'
  # 跨平台执行程序(如打开浏览器)
  gem 'launchy'
end
