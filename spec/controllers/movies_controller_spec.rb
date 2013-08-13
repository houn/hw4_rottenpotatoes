require 'spec_helper'

describe MoviesController  do
	describe 'find movie with same director' do
		it 'should call the model method that performs a search for movies with the same director' do
			#Movie.should_receive(:find_all_by_director).with("George Lucas")
			get :search_director, {:director => 'George Lucas'}
		end
		it 'should select the search results for rendering' do
			get :search_director, {:director => 'George Lucas'}
			response.should render_template('search_director')
		end
		it 'should make the find movie with same director results available to that template'
	end
end