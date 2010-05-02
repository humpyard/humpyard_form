require 'pickle'

Given /^the following (.+) records?$/ do |factory, table|  
  table.hashes.each do |hash|  
    Factory(factory, hash)  
  end  
end

Given /^the configured locales is "([^\"]*)"$/ do |locales|
  Humpyard::config.locales = (locales == ':default' ? nil : locales)
  Rails::Application.reload_routes!
end

Given /^the current locale is "([^\"]*)"$/ do |locale|
  I18n.locale = (locale == ':default' ? nil : locale)
end

Transform /^table:(?:.*,)?parent(?:,.*)?$/i do |table|
  table.map_headers! { |header| header.downcase }
  table.map_column!("parent") { |a| model(a) }
  table
end

Given /^#{capture_model} is the parent of #{capture_model}$/ do |parent, child|
  child = model(child)
  child.parent = model(parent)
  child.save!
end

When /^I click on "([^\"]*)" within "([^\"]*)"$/ do |link_text, selector|
  within(:css, selector) do
    find_link(link_text).click()
  end
end

When /^I hover over the css element "([^\"]*)"$/ do |selector|
  res = page.evaluate_script("window.setTimeout (function() {$('#{selector}').trigger('mouseover');}, 1)")
end

When /^I change the field "([^\"]*)" to "([^\"]*)"$/ do |attr, new_content|
  within(:css, ".ui-dialog form") do
    fill_in "element[#{attr}]", :with => new_content
  end
end

When /^I click "([^\"]*)" on the dialog$/ do |button_title|
  within(:css, ".ui-dialog") do
    click(button_title)
  end
end

Then /^put me the raw result$/ do
  # Only use this for debugging a output if you don't know what went wrong
  raise page.body
end

Then /^I should get a status code of (\d*)$/ do |status_code|
  page.driver.last_response.status.should == status_code.to_i
end

Then /^I should see a css element "([^\"]*)"$/ do |selector|
  page.has_css?(selector).should == true
end

Then /^I should see a button named "([^\"]*)" within "([^\"]*)"$/ do |name, selector|
  within(:css, selector) do
    but = find_link(name)
    but.should_not == nil
    but.visible?.should == true
  end
end

Then /^I should see \/([^\/]*)\/(?: within css element "([^\"]*)")?$/ do |re, scope_selector|
  regexp = Regexp.new(re)
  within(:css, scope_selector) do
    wait_until(15) { find(:css, ".text-element").text.match(regexp) rescue false }.should_not == nil
  end
end

Then /^the css element "([^\"]*)" should be within the window boundaries$/ do |selector|
  el = page.find(:css, selector)
  el_pos = page.evaluate_script('$("'+selector+'").offset()');
  el_height = page.evaluate_script('$("'+selector+'").height()');
  el_width = page.evaluate_script('$("'+selector+'").width()');
  win_height = page.evaluate_script('$(window).height()')
  win_width = page.evaluate_script('$(window).width()')
  if el_pos[:top].to_i >= win_height.to_i
    raise "top of element '#{selector}' is greater than the window height of #{win_height}"
  end
  if el_pos[:left].to_i >= win_width.to_i
    raise "left of element '#{selector}' is greater than the window height of #{win_height}"
  end
  if el_pos[:left].to_i + el_width.to_i < 0
    raise "left+width of element '#{selector}' is less than 0"
  end
  if el_pos[:top].to_i + el_height.to_i < 0
    raise "top+height of element '#{selector}' is less than 0"
  end
end

Then /^the dialog should be open$/ do
  wait_until(15) { page.has_css?(".ui-dialog") }.should == true
end

Then /^the dialog should be closed$/ do
  wait_until(15) { not page.has_css?(".ui-dialog") }.should == true
end

Then /^I should see the error "([^\"]*)" on the field "([^\"]*)"$/ do |msg, attr|
  within(:css, ".ui-dialog .attr_#{attr}") do
    wait_until(15) { find(:css, ".field-errors").text == msg rescue false }.should_not == nil
  end
end

When /^I switch to the dialog tab "([^\"]*)"$/ do |tabtitle|
  wait_until(15) { page.has_css?(".ui-dialog") }.should == true
  within(:css, ".ui-dialog") do
    link = find_link(tabtitle)
    link.click
    puts link['href']
    wait_until { find(:css, link['href']).visible? }.should == true
  end
end

