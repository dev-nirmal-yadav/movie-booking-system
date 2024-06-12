# frozen_string_literal: true

require_relative './file_parsers/csv_parser'

# This module provides a loader for File Parsing.
module FileParser
  class UnsupportedFormatError < StandardError; end
  class InvalidFileError < StandardError; end

  def self.load(file_path, &block)
    raise InvalidFileError unless valid_file?(file_path)

    extension = File.extname(file_path)

    raise UnsupportedFormatError, "Unsupported file format: #{extension}" unless extension.eql?('.csv')

    CSVParser.load(file_path, &block)
  end

  def self.valid_file?(file_path)
    File.exist?(file_path) && File.file?(file_path)
  end
end
