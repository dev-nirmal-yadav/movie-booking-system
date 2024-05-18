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
    before { show.book_seat(1) }

    it 'books a seat and updates the booked_seats array' do
      expect(show.booked_seats).to include(1)
    end

    it 'removes the booked seat from available seats' do
      expect(show.available_seats).not_to include(1)
    end
  end

  describe '#release_seat' do
    before do
      show.book_seat(1)
      show.release_seat(1)
    end

    it 'releases a booked seat and updates the booked_seats array' do
      expect(show.booked_seats).not_to include(1)
    end

    it 'adds the released seat back to available seats' do
      expect(show.available_seats).to include(1)
    end
  end

  describe '#available_seats' do
    it 'returns all seats when no seats are booked' do
      expect(show.available_seats.size).to eq(20)
    end

    it 'returns the correct available seats when some seats are booked' do
      show.book_seat(1)
      show.book_seat(2)
      expect(show.available_seats).not_to include(1, 2)
      expect(show.available_seats.size).to eq(18)
    end
  end

  describe '#available_seats_count' do
    it 'returns the correct count of available seats' do
      expect(show.available_seats_count).to eq(20)
      show.book_seat(1)
      expect(show.available_seats_count).to eq(19)
    end
  end
end
