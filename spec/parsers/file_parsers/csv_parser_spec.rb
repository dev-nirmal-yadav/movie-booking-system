# frozen_string_literal: true

require './lib/parsers/file_parsers/csv_parser'

RSpec.describe FileParser::CSVParser do
  describe '.load' do
    let(:csv_file_path) { 'spec/fixtures/movies.csv' }

    let(:expected_items) do
      {
        genre: 'Adventure',
        show_times: ['12:00 PM', '3:00 PM', '6:00 PM'],
        title: 'Jurassic Park',
        total_capacity: 30
      }
    end

    it 'parses a CSV file and yields each row to the given block' do
      parsed_items = described_class.load(csv_file_path) do |row|
        {
          title: row['title'],
          genre: row['genre'],
          total_capacity: row['totalcapacity'].to_i,
          show_times: row['showtimes'].split(',').map(&:strip)
        }
      end

      expect(parsed_items).to be_an(Array)
      expect(parsed_items[0]).to eq(expected_items)
    end
  end
end
