# frozen_string_literal: true

require './lib/services/book_ticket_service'

RSpec.describe BookTicketService do
  let(:movie) { double('Movie', title: 'Jurassic Park', genre: 'Adventure') }
  let(:show) { Show.new(movie:, show_time: '10:00 AM', total_capacity: 20) }
  let(:seat_numbers) { [1, 2, 3] }
  let(:options) { { movie:, show:, seat_numbers: } }

  describe '.call' do
    subject(:result) { described_class.call(options) }

    it 'books the seats' do
      result
      expect(show.booked_seats).to include(*seat_numbers)
    end

    it 'creates a ticket with the correct details' do
      ticket = result[:ticket]

      expect(ticket.movie).to eq(movie)
      expect(ticket.show).to eq(show)
      expect(ticket.seat_numbers).to eq(seat_numbers)
      expect(ticket.status).to eq(Ticket::BOOKED)
      expect(result[:message]).to eq('Ticket booked successfully!!')
    end
  end
end
