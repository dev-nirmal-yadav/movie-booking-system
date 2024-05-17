# frozen_string_literal: true

require_relative 'services/book_ticket_service'
require_relative 'services/cancel_ticket_service'

# MovieBookingSystem is the main entry point of the booking system.
class MovieBookingSystem
  FILE_PATH = 'data/movies.csv'

  attr_reader :movies, :prompt, :tickets

  def initialize
    @movies = []
    @prompt = TTY::Prompt.new
    @tickets = []
  end

  def run
    setup_movies
  end

  def book_ticket(options)
    response = BookTicketService.call(options)
    tickets.push response[:ticket]

    response
  end

  def cancel_ticket(ticket)
    CancelTicketService.call(ticket:)
  end

  private

  def setup_movies
    @movies = ImportMoviesService.import(FILE_PATH)
  rescue StandardError => e
    prompt.error "Failed importing movies: #{e.message}"
  end
end
