class Seat
  attr_reader :number, :seat_class

  def initialize(number:, seat_class:)
    @number = number
    @seat_class = seat_class
  end

  def to_s
    "#{number} (#{seat_class})"
  end
end