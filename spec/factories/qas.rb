# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :qa do |f|
  f.content "MyString"
  f.a_content "MyString"
  f.user ""
  f.a_user ""
end
