# Add a declarative step here for populating the DB with movies.
class CreateMovies < ActiveRecord::Migration
  def up
    create_table :movies do |m|
      m.string :title
      m.string :rating
      m.director :director
      m.string :release_date
    end
  end
end
CreateMovies.up

class Movie < ActiveRecord::Base
end

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
  assert movies_table.hashes.size == Movie.all.count
end


Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  titles = page.all("table#movies tbody tr td[1]").map {|t| t.text}
  assert titles.index(e1) < titles.index(e2) 
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end
When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

And /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  movie_director = Movie.find(3)

  assert movie_director['director'] == arg2

end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  visit path_to(page_name)
end

Given /^I check the following ratings: "(.*?)"$/ do |rating_list|
  rating_list.split(",").each do |field|
    field = field.strip
    step %Q{I check "ratings_#{field}"}
    step %Q{the "ratings_#{field}" checkbox should be checked}
  end
end

And /^I uncheck the other ratings: "(.*?)"$/ do |rating_list|
  rating_list.split(",").each do |field|
    field = field.strip
    step %Q{I uncheck "ratings_#{field}"}
    step %Q{the "ratings_#{field}" checkbox should not be checked}
  end
end

And /^I press the "(.*?)" button$/ do |refresh|
    step %Q{I press "#{refresh}"}
end


Then /^I should see the following ratings: "(.*?)"$/ do |rating_list|
  ratings = page.all("table#movies tbody tr td[2]").map! {|t| t.text}
  rating_list.split(",").each do |field|
    assert ratings.include?(field.strip)
  end
end

Then /^I should not see the following ratings: "(.*?)"$/ do |rating_list|
  ratings = page.all("table#movies tbody tr td[2]").map! {|t| t.text}
  rating_list.split(",").each do |field|
    assert !ratings.include?(field.strip)
  end
end

Given /^I check all ratings: "(.*?)"$/ do |rating_list|
  step %Q{I check the following ratings: "#{rating_list}"}
  #rating_list.split(",").each do |field|
  #  field = field.strip
  #  step %Q{I check "ratings_#{field}"}
  #  step %Q{the "ratings_#{field}" checkbox should be checked}
  #end
end

Then /^I "(.*?)" the page$/ do |refresh|
    step %Q{I press "#{refresh}"}
 # express the regexp above with the code you wish you had
end

Then /^I should see all of the movies$/ do
  rows = page.all("table#movies tbody tr td[1]").map! {|t| t.text}
  assert ( rows.size == Movie.all.count ) 
end

Then /^I should see no movies$/ do
  rows = page.all("table#movies tbody tr td[1]").map! {|t| t.text}
  assert rows.size == 0 
end

#Then /^I should see all the movies sorted by "(.*)"$/ do |sort|
#  debugger
#  rows = page.all("table#movies tbody tr td[1]").map! {|t| t.text}
#  Movie.all.sort(:"#{sort}")
#end


Then /^I should see all the movies sorted by "(.*?)"$/ do |sort|
  index = 0
  rows = page.all("table#movies tbody tr td[1]").map! {|t| t.text}
  rows.split(",")

  Movie.order(sort).each do |r|
    assert (r['title']==rows[index]), "Sorted #{r['title']} is equal with #{rows[index]}"
    index = index + 1
  end
end
