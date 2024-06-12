# frozen_string_literal: true

require_relative '../../lib/models/movie'

RSpec.describe Movie do
  let(:movie) { described_class.new(title: 'Jurassic Park', genre: 'Adventure') }
  let(:show) { double('Show') }

  describe '#initialize' do
    it 'sets the title' do
      expect(movie.title).to eq('Jurassic Park')
    end

    it 'sets the genre' do
      expect(movie.genre).to eq('Adventure')
    end

    it 'initializes with an empty array of shows' do
      expect(movie.shows).to eq([])
    end
  end

  describe '#add_show' do
    it 'adds a show to the shows array' do
      expect { movie.add_show(show) }.to change { movie.shows.size }.by(1)
      expect(movie.shows).to include(show)
    end
  end
end
