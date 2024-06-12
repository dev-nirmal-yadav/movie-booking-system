# frozen_string_literal: true

# ViewTicketsInteraction shows ticket information.
class ViewTicketsInteraction
  NO_TICKETS_BOOKED = 'No tickets booked yet'

  attr_reader :booking_system, :prompt

  def initialize(booking_system, prompt)
    @booking_system = booking_system
    @prompt = prompt
  end

  def call
    tickets = booking_system.tickets
    return prompt.warn NO_TICKETS_BOOKED if tickets.empty?

    tickets.each do |ticket|
      prompt.say '-----------------------'
      ticket_details = ticket.formatted_details
      prompt.ok(ticket_details)
    end
  end
end
