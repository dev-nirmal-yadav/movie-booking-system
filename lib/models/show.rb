# frozen_string_literal: true

# Show with movie, show_time and booked_seats
class Show
  attr_reader :movie, :show_time, :booked_seats

  def initialize(movie:, show_time:, total_capacity:)
    @movie = movie
    @show_time = show_time
    @total_capacity = total_capacity
    @booked_seats = []
  end

  def book_seat(seat_number)
    available_seats.delete(seat_number)
    booked_seats << seat_number
  end
end
