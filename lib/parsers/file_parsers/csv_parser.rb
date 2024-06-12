# frozen_string_literal: true

require 'csv'

module FileParser
  # CSV parser.
  module CSVParser
    def self.load(file_path)
      items = []

      CSV.foreach(file_path, headers: true) do |row|
        items << yield(row)
      end

      items
    end
  end
end
