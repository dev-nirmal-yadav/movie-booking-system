# frozen_string_literal: true

require 'securerandom'

# Represents all the booked ticket details
class Ticket
  attr_reader :id, :movie, :show, :seat_numbers
  attr_accessor :status

  STATUSES = [
    BOOKED = 'Booked',
    CANCELED = 'Canceled'
  ].freeze

  def initialize(movie, show, seat_numbers)
    @id = SecureRandom.uuid
    @movie = movie
    @show = show
    @seat_numbers = seat_numbers
    @status = BOOKED
  end

  def formatted_details
    "ID: #{id} \n" \
    "Status: #{status} \n" \
    "Movie: #{movie.title} \n" \
    "Show time: #{show.show_time} \n" \
    "Seat Numbers: #{seat_numbers}"
  end

  STATUSES.each do |status|
    define_method("#{status.downcase}?") { self.status == status }
  end

  def cancel!
    self.status = CANCELED
  end
end
