# frozen_string_literal: true

require './lib/movie_booking_system'
require './lib/services/import_movies_service'
require './lib/models/movie'
require './lib/models/show'
require './lib/models/ticket'

RSpec.describe MovieBookingSystem do
  let(:movie_booking_system) { described_class.new }
  let(:prompt) { double(TTY::Prompt) }

  before do
    allow(TTY::Prompt).to receive(:new).and_return(prompt)
    allow(prompt).to receive(:say)
    allow(prompt).to receive(:ok)
    allow(prompt).to receive(:error)
  end

  describe '#initialize' do
    it 'initializes with an empty list of movies and a TTY prompt' do
      expect(movie_booking_system.movies).to be_empty
      expect(movie_booking_system.prompt).to be(prompt)
    end
  end

  describe '#run' do
    context 'when movies are successfully imported' do
      let(:movies) { [double('Movie1'), double('Movie2')] }

      before do
        allow(ImportMoviesService).to receive(:import).and_return(movies)
        allow(prompt).to receive(:select).with('Please choose an option:', ['Book Ticket', 'Cancel Ticket', 'View Tickets', 'Exit']).and_return('Exit')
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
        allow(prompt).to receive(:select).with('Please choose an option:', ['Book Ticket', 'Cancel Ticket', 'View Tickets', 'Exit']).and_return('Exit')
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

  let(:movie) { Movie.new(title: 'Jurassic Park', genre: 'Adventure') }
  let(:show) { Show.new(movie: movie, show_time: '10:00 AM', total_capacity: 20) }
  let(:seat_numbers) { [1, 2, 3] }
  let(:ticket) { Ticket.new(movie, show, seat_numbers) }

  describe '#book_ticket' do
    let(:options) { { movie: movie, show: show, seat_numbers: seat_numbers } }

    before do
      allow(BookTicketService).to receive(:call).and_return(ticket: ticket, message: 'Booking successful!!')
      allow(movie_booking_system).to receive(:tickets).and_return([ticket])
    end

    it 'triggers BookTicketService and books the ticket' do
      result = movie_booking_system.book_ticket(options)
      expect(result[:ticket]).to eq(ticket)
      expect(result[:ticket].status).to eq(Ticket::BOOKED)
    end
  end

  describe '#cancel_ticket' do

    before do
      allow(movie_booking_system).to receive(:tickets).and_return([ticket])
      ticket.cancel!
    end

    it 'triggers CancelTicketService and cancels the ticket' do
      result = movie_booking_system.cancel_ticket(ticket)
      expect(result[:ticket].status).to eq(Ticket::CANCELED)
    end
  end
end
