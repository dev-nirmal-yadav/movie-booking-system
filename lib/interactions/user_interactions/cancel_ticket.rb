# frozen_string_literal: true

# CancelTicket triggers the cancellation process and handles all the related logic
module CancelTicket
  GO_BACK = 'Go Back'
  
  def cancel_ticket
    booked_tickets = booking_system.tickets.select(&:booked?)
    return prompt.warn 'No tickets booked yet' if booked_tickets.empty?

    selected_ticket = select_ticket(booked_tickets)
    return if selected_ticket.nil?

    return if confirm_cancellation?(selected_ticket)

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

  def confirm_cancellation?(ticket)
    prompt.no?('Are you sure you want to cancel this ticket?')
  end
end
