# frozen_string_literal: true

require_relative '../services/import_movies_service'
require_relative './user_interactions/book_ticket_interaction'
require_relative './user_interactions/cancel_ticket_interaction'
require_relative './user_interactions/view_tickets_interaction'

# This service is responsible for Interacting with the User
class UserInteractionService

  MENU_OPTIONS = [
    'Book Ticket',
    'Cancel Ticket',
    'View Tickets',
    'Exit'
  ].freeze

  INTERACTION_CLASSES = {
    'Book Ticket' => BookTicketInteraction,
    'Cancel Ticket' => CancelTicketInteraction,
    'View Tickets' => ViewTicketsInteraction
  }.freeze

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
    interaction_class = INTERACTION_CLASSES[choice]
    interaction_class&.new(booking_system, prompt)&.call
  end
end
