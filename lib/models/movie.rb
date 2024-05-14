  # frozen_string_literal: true

  # Movie with title, genre and shows
  class Movie
    attr_reader :title, :genre, :shows

    def initialize(title:, genre:)
      @title = title
      @genre = genre
      @shows = []
    end

    def add_show(show)
      shows << show
    end
  end
