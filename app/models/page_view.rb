# == Schema Information
# Schema version: 20081103115406
#
# Table name: page_views
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      
#  request_url :string(255)     
#  ip_address  :string(255)     
#  referer     :string(255)     
#  user_agent  :string(255)     
#  created_at  :datetime        
#  updated_at  :datetime        
#

class PageView < ActiveRecord::Base
end
