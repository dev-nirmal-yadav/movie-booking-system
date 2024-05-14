# frozen_string_literal: true

require './lib/parsers/file_parser'

RSpec.describe FileParser do
  describe '.load' do
    let(:csv_file_path) { 'spec/fixtures/movies.csv' }
    let(:invalid_file_path) { 'spec/fixtures/non_existent.csv' }
    let(:unsupported_file_path) { 'spec/fixtures/movies.txt' }

    context 'when the file is valid and supported' do
      it 'loads and parses a CSV file' do
        expect(described_class::CSVParser).to receive(:load).with(csv_file_path)

        described_class.load(csv_file_path)
      end
    end

    context 'when the file does not exist' do
      it 'raises an InvalidFileError' do
        expect {
          described_class.load(invalid_file_path) { |row| row }
        }.to raise_error(described_class::InvalidFileError)
      end
    end

    context 'when the file format is unsupported' do
      before do
        allow(described_class).to receive(:valid_file?).with(unsupported_file_path)
          .and_return(true)
      end

      it 'raises an UnsupportedFormatError' do
        expect {
          FileParser.load(unsupported_file_path) { |row| row }
        }.to raise_error(FileParser::UnsupportedFormatError, 'Unsupported file format: .txt')
      end
    end
  end
end
