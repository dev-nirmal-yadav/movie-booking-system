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
end
