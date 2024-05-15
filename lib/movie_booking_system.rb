# frozen_string_literal: true

# MovieBookingSystem is the main entry point of the booking system.
class MovieBookingSystem
  FILE_PATH = 'data/movies.csv'

  attr_reader :movies, :prompt

  def initialize
    @movies = []
    @prompt = TTY::Prompt.new
  end

  def run
    setup_movies
  end

  private

  def setup_movies
    @movies = ImportMoviesService.import(FILE_PATH)
  rescue StandardError => e
    prompt.error "Failed importing movies: #{e.message}"
  end
end
