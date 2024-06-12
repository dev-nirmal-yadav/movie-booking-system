# frozen_string_literal: true

# CancelTicketInteraction triggers the cancellation process and handles all the related logic
class CancelTicketInteraction
  GO_BACK = 'Go Back'
  NO_TICKETS_BOOKED = 'No tickets booked yet'

  attr_reader :booking_system, :prompt

  def initialize(booking_system, prompt)
    @booking_system = booking_system
    @prompt = prompt
  end

  def call
    booked_tickets = booking_system.tickets.select(&:booked?)
    return prompt.warn NO_TICKETS_BOOKED if booked_tickets.empty?

    selected_ticket = select_ticket(booked_tickets)

    return if selected_ticket.nil? || confirm_cancellation?

    result = booking_system.cancel_ticket(selected_ticket)
    prompt.ok result[:message]
    prompt.ok result[:ticket].formatted_details
  end

  private

  def select_ticket(booked_tickets)
    options = booked_tickets.map(&:formatted_details) << GO_BACK
    choice = prompt.select('Select a ticket to cancel:', options)
    return if choice.eql?(GO_BACK)

    booked_tickets.find { |ticket| ticket.formatted_details == choice }
  end

  def confirm_cancellation?
    prompt.no?('Are you sure you want to cancel this ticket?')
  end
end
