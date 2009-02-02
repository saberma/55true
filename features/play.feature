Feature: Play without register

Scenario: Get Question
Given I am on the homepage
When I follow "play"
Then I should see "请先注册或登录"
