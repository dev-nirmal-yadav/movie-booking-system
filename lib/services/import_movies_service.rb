# frozen_string_literal: true

require_relative '../parsers/file_parser'
require_relative '../models/movie'
require_relative '../models/show'

# Importer to import the movies data
class ImportMoviesService
  def self.import(file_path)
    FileParser.load(file_path) do |row|
      create_movie_from_row(row)
    end
  end

  private

  def self.create_movie_from_row(row)
    movie = Movie.new(title: row['title'], genre: row['genre'])
    show_times = row['showtimes'].split(',').map(&:strip)
    show_times.each do |show_time|
      show = Show.new(movie:, show_time:, total_capacity: row['totalcapacity'].to_i)
      movie.add_show(show)
    end
    movie
  end
end
