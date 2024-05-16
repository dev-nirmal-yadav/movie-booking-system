# frozen_string_literal: true

require_relative '../../lib/models/show'

RSpec.describe Show do
  let(:movie) { double('Movie') }
  let(:show) { Show.new(movie: movie, show_time: '10:00 AM', total_capacity: 20) }

  describe '#initialize' do
    it 'initializes with a movie' do
      expect(show.movie).to eq(movie)
    end

    it 'initializes with a show_time' do
      expect(show.show_time).to eq('10:00 AM')
    end

    it 'initializes with an empty booked_seats array' do
      expect(show.booked_seats).to eq([])
    end
  end

  describe '#book_seat' do
    it 'books a seat and updates the booked_seats array' do
      show.book_seat(1)
      expect(show.booked_seats).to include(1)
    end

    it 'removes the booked seat from available seats' do
      show.book_seat(1)
      expect(show.available_seats).not_to include(1)
    end
  end
end
