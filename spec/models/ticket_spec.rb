# frozen_string_literal: true

require_relative '../../lib/models/ticket'

RSpec.describe Ticket do
  let(:movie) { double('Movie', title: 'Jurassic Park', genre: 'Adventure') }
  let(:show) { double('Show', movie:, show_time: '10:00 AM', total_capacity: 20) }
  let(:seat_numbers) { [1, 2, 3] }
  let(:ticket) { described_class.new(movie, show, seat_numbers) }

  describe '#initialize' do
    it 'initializes with an ID, movie, show, seat numbers, and status' do
      expect(ticket.id).not_to be_nil
      expect(ticket.movie).to eq(movie)
      expect(ticket.show).to eq(show)
      expect(ticket.seat_numbers).to eq(seat_numbers)
      expect(ticket.status).to eq(described_class::BOOKED)
    end
  end

  describe '#booked?' do
    it { expect(ticket.booked?).to be_truthy }
  end

  describe '#canceled?' do
    before { ticket.cancel! }

    it { expect(ticket.canceled?).to be_truthy }
  end

  describe '#cancel!' do
    it 'cancels the ticket' do
      ticket.cancel!
      expect(ticket.status).to eq(described_class::CANCELED)
    end
  end
end
