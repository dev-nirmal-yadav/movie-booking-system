# frozen_string_literal: true

require './lib/services/import_movies_service'

RSpec.describe ImportMoviesService do
  describe '.import' do
    let(:file_path) { 'spec/fixtures/movies.csv' }

    it 'imports movies from a CSV file and creates Movie and Show objects' do
      movies = described_class.import(file_path)

      expect(movies).to be_an(Array)
      expect(movies.size).to eq(5)

      matrix = movies.find { |movie| movie.title == 'The Matrix' }
      expect(matrix.genre).to eq('Science Fiction')
      expect(matrix.shows.size).to eq(3)
      expect(matrix.shows.first.show_time).to eq('10:00 AM')
      expect(matrix.shows.first.available_seats_count).to eq(20)
    end
  end
end
