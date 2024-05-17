# frozen_string_literal: true

# This service is responsible for cancel the booked ticket
class CancelTicketService
  def self.call(ticket:)
    ticket.cancel!
    ticket.seat_numbers.each { |seat_number| ticket.show.release_seat(seat_number) }
    { ticket:, message: 'Ticket canceled successfully!!' }
  end
end
