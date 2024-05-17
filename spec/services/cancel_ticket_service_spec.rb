# frozen_string_literal: true

require './lib/services/cancel_ticket_service'
require './lib/models/show'
require './lib/models/ticket'

RSpec.describe CancelTicketService do
  let(:movie) { double('Movie', title: 'Jurassic Park', genre: 'Adventure') }
  let(:show) { Show.new(movie: movie, show_time: '10:00 AM', total_capacity: 20) }
  let(:seat_numbers) { [1, 2, 3] }
  let(:ticket) { Ticket.new(movie, show, seat_numbers) }

  describe '.call' do
    subject(:result) { described_class.call(ticket:) }

    before { ticket.cancel! }

    it 'cancels the selected ticket' do
      expect(ticket.status).to eq(Ticket::CANCELED)
      expect(result[:message]).to eq('Ticket canceled successfully!!')
    end
  end
end
