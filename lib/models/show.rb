# frozen_string_literal: true

require_relative './seat'
# Show with movie, show_time and booked_seats
class Show
  attr_reader :movie, :show_time, :booked_seats

  def initialize(movie:, show_time:, total_capacity:, vip_capacity:)
    @movie = movie
    @show_time = show_time
    @total_capacity = total_capacity
    @vip_capacity = vip_capacity
    @booked_seats = []
    setup_seats
  end

  def available_seats
    @seats.reject { |seat| booked_seats.include?(seat.number) }
  end

  def book_seat(seat_number)
    available_seats.delete(seat_number)
    booked_seats << seat_number
  end

  def release_seat(seat_number)
    available_seats.push(seat_number)
    booked_seats.delete(seat_number)
  end

  def available_seats_count
    available_seats.size
  end

  private

  def setup_seats
    @seats = []
    (1..@vip_capacity).each do |number|
      @seats << Seat.new(number: number, seat_class: 'VIP')
    end

    ((@vip_capacity + 1)..@total_capacity).each do |number|
      @seats << Seat.new(number: number, seat_class: 'Classic')
    end
  end
end
