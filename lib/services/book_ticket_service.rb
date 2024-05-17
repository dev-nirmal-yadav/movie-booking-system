# frozen_string_literal: true

require_relative '../models/ticket'

# This service is responsible for booking the ticket
class BookTicketService
  def self.call(options)
    movie = options[:movie]
    show = options[:show]
    seat_numbers = options[:seat_numbers]

    seat_numbers.each { |seat_number| show.book_seat(seat_number) }

    ticket = Ticket.new(movie, show, seat_numbers)
    {
      ticket:,
      message: 'Ticket booked successfully!!'
    }
  end
end
