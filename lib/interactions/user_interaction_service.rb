# frozen_string_literal: true

require_relative '../services/import_movies_service'
require_relative './user_interactions/book_ticket'
require_relative './user_interactions/cancel_ticket'

# This service is responsible for Interacting with the User
class UserInteractionService
  include BookTicket
  include CancelTicket

  MENU_OPTIONS = [
    'Book Ticket',
    'Cancel Ticket',
    'View Tickets',
    'Exit'
  ].freeze

  attr_reader :booking_system, :prompt

  def initialize(booking_system, prompt)
    @booking_system = booking_system
    @prompt = prompt
  end

  def run
    prompt.say 'Welcome to the Movie Booking App!'
    prompt.say '*********************************'

    loop do
      choice = prompt.select('Please choose an option:', MENU_OPTIONS)
      prompt.ok('Thanks for using Movie Booking App!') && break if choice.eql?('Exit')

      handle_choice(choice)
    end
  end

  private

  def handle_choice(choice)
    method_name = choice.downcase.gsub(' ', '_')
    send(method_name)
  end

  def view_tickets
    tickets = booking_system.tickets
    return prompt.warn 'No tickets booked in the past' if tickets.empty?

    tickets.each do |ticket|
      prompt.say '-----------------------'
      ticket_details = ticket.formatted_details
      prompt.ok(ticket_details)
    end
  end
end
