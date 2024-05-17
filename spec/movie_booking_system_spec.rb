# frozen_string_literal: true

require './lib/movie_booking_system'
require './lib/services/import_movies_service'

RSpec.describe MovieBookingSystem do
  let(:movie_booking_system) { described_class.new }

  describe '#initialize' do
    it 'initializes with an empty list of movies and a TTY prompt' do
      expect(movie_booking_system.movies).to be_empty
      expect(movie_booking_system.prompt).to be_instance_of(TTY::Prompt)
    end
  end

  describe '#run' do
    context 'when movies are successfully imported' do
      let(:movies) { [double('Movie1'), double('Movie2')] }

      before do
        allow(ImportMoviesService).to receive(:import).and_return(movies)
      end

      it 'imports movies and assigns them to the system' do
        expect(movie_booking_system.movies).to be_empty

        movie_booking_system.run

        expect(movie_booking_system.movies).to eq(movies)
      end
    end

    context 'when importing movies fails' do
      before do
        allow(ImportMoviesService).to receive(:import).and_raise(StandardError, 'File not found')
      end

      it 'displays an error message' do
        expect(movie_booking_system.prompt).to receive(:error).with('Failed importing movies: File not found')

        movie_booking_system.run
      end

      it 'leaves movies list empty' do
        movie_booking_system.run

        expect(movie_booking_system.movies).to be_empty
      end
    end
  end
end
