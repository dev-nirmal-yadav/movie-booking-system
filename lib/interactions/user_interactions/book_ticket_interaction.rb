# frozen_string_literal: true

# BookTicketInteraction triggers the booking process and handles all the logic
class BookTicketInteraction
  NO_SEATS_AVAILABLE = 'No seats available for this show'
  LIMITED_SEATS_AVAILABLE = 'No of seats exceeds total available seats'
  INVALID_SELECTION = 'Invalid selection'
  GO_BACK = 'Go Back'

  attr_reader :booking_system, :prompt

  def initialize(booking_system, prompt)
    @booking_system = booking_system
    @prompt = prompt
  end

  def call
    loop do
      movie = select_movie
      break if movie.eql?(GO_BACK)

      show = select_show(movie)
      break if show.eql?(GO_BACK)

      process_ticket_booking(movie, show)
      break
    end
  end

  private

  def select_movie
    prompt_for_selection('Choose a movie to book tickets:', booking_system.movies, &:title)
  end

  def select_show(movie)
    prompt_for_selection("Choose a showtime for the movie '#{movie.title}':", movie.shows) do |show|
      "#{show.show_time} (#{show.available_seats_count} seats available)"
    end
  end

  def prompt_for_selection(prompt_message, collection, &block)
    options = collection.map(&block) + [GO_BACK]
    selected_option = prompt.select(prompt_message, options)
    return GO_BACK if selected_option.eql?(GO_BACK)

    collection.find { |item| yield(item) == selected_option }
  end

  def process_ticket_booking(movie, show)
    return prompt.error NO_SEATS_AVAILABLE if show.available_seats.empty?

    display_available_seats(show)
    num_of_tickets = number_of_tickets
    return unless valid_ticket_selection?(num_of_tickets, show)

    seat_numbers = select_seat_numbers(num_of_tickets, show.available_seats)
    return prompt.warn 'Booking cancelled!' unless confirm_booking?

    finalize_booking(movie, show, seat_numbers)
  end

  def display_available_seats(show)
    prompt.say "Available seats: #{show.available_seats.join(', ')}"
  end

  def number_of_tickets
    prompt.ask('How many tickets would you like to book?', convert: :int)
  end

  def valid_ticket_selection?(num_of_tickets, show)
    return prompt.error(INVALID_SELECTION) if num_of_tickets.nil?
    return prompt.error(LIMITED_SEATS_AVAILABLE) if num_of_tickets > show.available_seats_count

    true
  end

  def confirm_booking?
    prompt.yes?('Are you sure you want to book this ticket?')
  end

  def select_seat_numbers(num_of_tickets, available_seats)
    num_of_tickets.times.map { get_seat_number_from_user(available_seats) }
  end

  def get_seat_number_from_user(available_seats)
    loop do
      seat_number = prompt.ask('Enter seat number (choose from available seats):', convert: :int)
      return seat_number if available_seats.include?(seat_number)

      prompt.error "Seat number #{seat_number} is not available. Please choose from available seats."
    end
  end

  def finalize_booking(movie, show, seat_numbers)
    result = booking_system.book_ticket(movie:, show:, seat_numbers:)

    prompt.ok result[:message]
    prompt.ok result[:ticket].formatted_details
  end
end
